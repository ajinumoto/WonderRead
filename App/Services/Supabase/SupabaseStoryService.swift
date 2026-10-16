import Foundation

enum SupabaseStoryService {
  static func fetchCollectionVersions() async -> [CollectionVersionDTO]? {
    guard SupabaseConfiguration.isConfigured, let url = versionsURL() else { return nil }
    let request = getRequest(url: url, timeout: 6)
    guard let (data, response) = await getResponse(for: request), isSuccessful(response) else { return nil }
    return try? JSONDecoder().decode([CollectionVersionDTO].self, from: data)
  }

  static func fetchCollections(
    language: String? = nil,
    limit: Int = 10,
    offset: Int = 0,
    forceRefresh: Bool = false
  ) async -> [StoryCollection] {
    let query = SupabaseCollectionQuery(language: language, limit: limit, offset: offset)
    return await fetchCollections(query: query, forceRefresh: forceRefresh)
  }

  static func fetchCollections(
    query: SupabaseCollectionQuery,
    forceRefresh: Bool = false
  ) async -> [StoryCollection] {
    if query.offset == 0 && !forceRefresh, let cached = await reusableCache(for: query) {
      return cached
    }
    guard SupabaseConfiguration.isConfigured else {
      return await fallbackCached(for: query)
    }
    return await fetchCollectionsFromServer(query)
  }

  static func fetchChapters(for collectionID: UUID) async -> [StoryChapter] {
    guard SupabaseConfiguration.isConfigured, let url = chapterURL(collectionID) else { return [] }
    let request = getRequest(url: url, timeout: 10)
    guard let (data, response) = await getResponse(for: request),
          isSuccessful(response),
          let dtos = try? JSONDecoder().decode([SupabaseChapterDTO].self, from: data) else { return [] }
    return SupabaseStoryDataMapper.chapters(from: dtos)
  }

  static func hydrateChaptersIfNeeded(for collection: StoryCollection) async -> StoryCollection {
    guard collection.chapters.isEmpty else { return collection }
    let fetched = await fetchChapters(for: collection.id)
    guard !fetched.isEmpty else { return collection }
    var updated = collection
    updated.chapters = fetched
    await SupabaseStoryCache.shared.updateChapters(fetched, for: collection.id, language: collection.language)
    return updated
  }

  private static func reusableCache(for query: SupabaseCollectionQuery) async -> [StoryCollection]? {
    guard let cached = await cachedCollections(for: query), !cached.isEmpty else { return nil }
    guard let serverVersions = await fetchCollectionVersions() else { return cached }
    let matches = await SupabaseStoryCache.shared.isCacheMatchingServer(
      cached: cached,
      serverVersions: serverVersions,
      filterLanguage: query.language
    )
    return matches ? cached : nil
  }

  private static func fetchCollectionsFromServer(_ query: SupabaseCollectionQuery) async -> [StoryCollection] {
    guard let url = SupabaseCollectionURLMapper.collectionsURL(baseURL: SupabaseConfiguration.projectURL, query: query) else {
      return await fallbackCached(for: query)
    }
    let request = getRequest(url: url, timeout: 10)
    guard let (data, response) = await getResponse(for: request) else { return await fallbackCached(for: query) }
    if response.statusCode == 400, query.language != nil { return await retryWithoutLanguage(request, query: query) }
    guard isSuccessful(response), let dtos = decodedCollections(from: data), !dtos.isEmpty else {
      return await fallbackCached(for: query)
    }
    return await persistCollections(SupabaseStoryDataMapper.collections(from: dtos), for: query)
  }

  private static func retryWithoutLanguage(_ request: URLRequest, query: SupabaseCollectionQuery) async -> [StoryCollection] {
    guard let url = SupabaseCollectionURLMapper.fallbackURL(
      baseURL: SupabaseConfiguration.projectURL,
      limit: query.limit,
      offset: query.offset
    ) else { return await fallbackCached(for: query) }
    var fallbackRequest = request
    fallbackRequest.url = url
    guard let (data, response) = await getResponse(for: fallbackRequest),
          isSuccessful(response),
          let dtos = decodedCollections(from: data), !dtos.isEmpty else {
      return await fallbackCached(for: query)
    }
    let collections = fallbackCollections(dtos, language: query.language)
    return await persistCollections(collections, for: query)
  }

  private static func fallbackCollections(_ dtos: [SupabaseCollectionDTO], language: String?) -> [StoryCollection] {
    let collections = SupabaseStoryDataMapper.collections(from: dtos)
    let filtered = collections.filter { $0.language == (language ?? "en") }
    return filtered.isEmpty ? collections : filtered
  }

  private static func persistCollections(
    _ collections: [StoryCollection],
    for query: SupabaseCollectionQuery
  ) async -> [StoryCollection] {
    if query.offset == 0 {
      await SupabaseStoryCache.shared.save(collections, language: query.cacheKey)
    } else {
      await SupabaseStoryCache.shared.merge(collections, language: query.cacheKey)
    }
    return collections
  }

  private static func fallbackCached(for query: SupabaseCollectionQuery) async -> [StoryCollection] {
    guard let cached = await cachedCollections(for: query), !cached.isEmpty else { return [] }
    guard query.offset > 0 else { return cached }
    guard query.offset < cached.count else { return [] }
    let endIndex = min(query.offset + query.limit, cached.count)
    return Array(cached[query.offset..<endIndex])
  }

  private static func cachedCollections(for query: SupabaseCollectionQuery) async -> [StoryCollection]? {
    await SupabaseStoryCache.shared.load(language: query.cacheKey)
  }

  private static func decodedCollections(from data: Data) -> [SupabaseCollectionDTO]? {
    try? JSONDecoder().decode([SupabaseCollectionDTO].self, from: data)
  }

  private static func isSuccessful(_ response: HTTPURLResponse) -> Bool {
    (200..<300).contains(response.statusCode)
  }

  private static func getResponse(for request: URLRequest) async -> (Data, HTTPURLResponse)? {
    guard let (data, response) = try? await URLSession.shared.data(for: request),
          let httpResponse = response as? HTTPURLResponse else { return nil }
    return (data, httpResponse)
  }

  private static func getRequest(url: URL, timeout: TimeInterval) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval = timeout
    request.setValue(SupabaseConfiguration.anonKey, forHTTPHeaderField: "apikey")
    request.setValue("Bearer \(SupabaseConfiguration.anonKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    return request
  }

  private static func versionsURL() -> URL? {
    URL(string: "\(SupabaseConfiguration.projectURL)/rest/v1/story_collections?select=id,version,language&order=order_index.asc")
  }

  private static func chapterURL(_ collectionID: UUID) -> URL? {
    URL(string: "\(SupabaseConfiguration.projectURL)/rest/v1/story_chapters?collection_id=eq.\(collectionID.uuidString)&order=number.asc")
  }
}
