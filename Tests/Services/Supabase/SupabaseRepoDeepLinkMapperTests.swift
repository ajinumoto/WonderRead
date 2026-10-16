import Foundation
import Testing
@testable import WonderRead

struct SupabaseRepoDeepLinkMapperTests {
  @Test func parsesValidDeepLinkWithAllParameters() {
    let urlString = "wonderread://install-repo?url=https%3A%2F%2Fxyz.supabase.co&key=mock_key_123&name=Koleksi%20Nusantara"
    guard let url = URL(string: urlString) else {
      Issue.record("URL creation failed")
      return
    }
    let payload = SupabaseRepoDeepLinkMapper.parse(url: url)
    #expect(payload?.projectURL == "https://xyz.supabase.co")
    #expect(payload?.anonKey == "mock_key_123")
    #expect(payload?.repoName == "Koleksi Nusantara")
  }

  @Test func parsesValidDeepLinkWithDefaultNameWhenNameOmitted() {
    let urlString = "wonderread://install-repo?url=https%3A%2F%2Fabc.supabase.co&key=anon_key_456"
    guard let url = URL(string: urlString) else {
      Issue.record("URL creation failed")
      return
    }
    let payload = SupabaseRepoDeepLinkMapper.parse(url: url)
    #expect(payload?.projectURL == "https://abc.supabase.co")
    #expect(payload?.anonKey == "anon_key_456")
    #expect(payload?.repoName == "New Story Repository")
  }

  @Test func rejectsInvalidSchemeOrHost() {
    let wrongScheme = URL(string: "https://install-repo?url=https%3A%2F%2Fxyz.supabase.co&key=123")!
    let wrongHost = URL(string: "wonderread://unknown-action?url=https%3A%2F%2Fxyz.supabase.co&key=123")!
    #expect(SupabaseRepoDeepLinkMapper.parse(url: wrongScheme) == nil)
    #expect(SupabaseRepoDeepLinkMapper.parse(url: wrongHost) == nil)
  }

  @Test func rejectsMissingOrEmptyRequiredParameters() {
    let missingKey = URL(string: "wonderread://install-repo?url=https%3A%2F%2Fxyz.supabase.co")!
    let missingUrl = URL(string: "wonderread://install-repo?key=123")!
    let emptyUrl = URL(string: "wonderread://install-repo?url=&key=123")!
    #expect(SupabaseRepoDeepLinkMapper.parse(url: missingKey) == nil)
    #expect(SupabaseRepoDeepLinkMapper.parse(url: missingUrl) == nil)
    #expect(SupabaseRepoDeepLinkMapper.parse(url: emptyUrl) == nil)
  }
}
