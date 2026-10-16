# WonderRead (Lentera) Code Audit

Generated 2026-10-16. Scope: ~275 Swift files across WonderRead application targets and unit tests.

Findings cite `path/to/file.swift:LINE` so you can jump straight to them in Xcode. Each item has a recommended action; no breaking changes were introduced.

---

## 1. Executive summary

Top items to address, in priority order:

1. **[Critical] Insecure Deep Link Repository Hijacking & Silent Cache Wipe** — §6.1 — `App/ContentView.swift:82-96`. Arbitrary external links instantly overwrite Supabase backend configuration and wipe user cache without confirmation.
2. **[High] Path Traversal in Local Illustration File Resolver** — §6.2 — `App/Features/Stories/Components/StoryImageLoader.swift:25-29`. Non-HTTP illustration URLs allow relative path traversal reading arbitrary sandbox files.
3. **[High] Plaintext Storage of Supabase Anon Key in UserDefaults** — §6.3 — `App/Services/Supabase/SupabaseConfiguration.swift:32-44`. API keys stored in unencrypted plist file rather than Keychain.
4. **[High] Unsanitized AI Custom Idea Direct Prompt Interpolation** — §6.4 — `App/Services/AI/StoryPromptTemplate.swift:18-24`. Custom idea strings directly interpolated without prompt injection defenses.
5. **[Medium] Insecure HTTP Scheme Allowed for Remote Backend** — §6.5 — `App/Services/Supabase/SupabaseConfiguration.swift:55`. Scheme validator permits unencrypted remote HTTP endpoints.
6. **[Medium] Missing Explicit AI Safety Settings for Child Readers** — §6.6 — `App/Services/AI/GeminiRequestMapper.swift:11-16`. Gemini generation payload lacks strict safety filter categories.
7. **[Medium] Children's Privacy (COPPA) Missing Parental Gate** — §6.7 — `App/Features/Settings/StoryProfileSettingsContent.swift:9-24`. Child nickname and age transmission to AI lacks parental challenge gate.
8. **[Low] Destructive SwiftData Store Reset on ModelContainer Error** — §5.1 — `App/Database/StoryDatabaseContainer.swift:56-61`. Unconditionally deletes store files without backup upon migration error.
9. **[Low] Redundant Keychain Update/Insert Loop** — §6.8 — `App/Services/Security/SecureAPIKeyStore.swift:68-77`. Accessible attributes in `SecItemUpdate` can fail on older iOS runtimes.

---

## 2. Quick wins (≤30 min each)

- **Sanitize filename in illustration resolver** — `App/Features/Stories/Components/StoryImageLoader.swift:25-29`. Use `lastPathComponent` and enforce image extension checks.
- **Enforce HTTPS for remote Supabase endpoints** — `App/Services/Supabase/SupabaseConfiguration.swift:55`. Reject `http://` unless host is `localhost` or `127.0.0.1`.
- **Add explicit safety settings to Gemini request** — `App/Services/AI/GeminiRequestMapper.swift:11-16`. Include `BLOCK_LOW_AND_ABOVE` thresholds on all harm categories.
- **Add confirmation alert for incoming deep link repository switch** — `App/ContentView.swift:82-96`. Prompt user before committing changes.

---

## 3. Concurrency

_No findings._ The codebase adheres cleanly to Swift 6 strict concurrency, utilizing `@ModelActor`, `@MainActor`, and structured concurrency.

---

## 4. API modernity

_No findings._ Modern SwiftUI primitives (`@Observable`, `@State`, `NavigationStack`, `SwiftData`) are uniformly adopted.

---

## 5. Bugs / logic errors

### 5.1 Destructive SwiftData Store Reset on Initialization Error
- **Location:** `App/Database/StoryDatabaseContainer.swift:56-61`
- **What:** When `ModelContainer` fails to initialize, `cleanStoreFiles` unconditionally deletes `.store`, `-shm`, and `-wal` files.
- **Why:** Any minor model migration glitch causes permanent data loss of local reading progress and generated stories.
- **Action:** Archive or rename corrupt store files before re-creating the database container.
- **Severity:** Low

---

## 6. Security

### 6.1 Insecure Deep Link Repository Hijacking & Silent Cache Wipe
- **Location:** `App/ContentView.swift:82-96`
- **What:** Incoming URL scheme `wonderread://install-repo` immediately modifies `SupabaseConfiguration` and clears story cache without user consent.
- **Why:** Allows malicious web pages or apps to hijack the child story source or execute a Denial of Service on local storage.
- **Action:** Store incoming payload in pending state and present an explicit confirmation dialog via dedicated `RepoConfirmationAlertModifier` and `RepoAlertMessageMapper` before applying changes.
- **Severity:** Critical
- **Status:** Resolved

### 6.2 Path Traversal in Local Illustration File Resolver
- **Location:** `App/Features/Stories/Components/StoryImageLoader.swift:25-29`
- **What:** Non-HTTP image URLs are passed directly to `StoryArchive.illustrationURL` which uses `appendingPathComponent`.
- **Why:** Malicious payload containing `../` can traverse directories inside the app sandbox and attempt reading sensitive files.
- **Action:** Sanitize filenames with `(filename as NSString).lastPathComponent` and verify sandbox directory prefix.
- **Severity:** High

### 6.3 Plaintext Storage of Supabase Anon Key in UserDefaults
- **Location:** `App/Services/Supabase/SupabaseConfiguration.swift:32-44`
- **What:** Supabase anonymous API key is stored in `UserDefaults.standard` rather than Keychain.
- **Why:** Accidental entry of `service_role` keys results in secret keys written to unencrypted plist files.
- **Action:** Store user-entered keys in Apple Keychain via `SecureAPIKeyStore` and reject keys containing `service_role`.
- **Severity:** High

### 6.4 Unsanitized AI Custom Idea Direct Prompt Interpolation
- **Location:** `App/Services/AI/StoryPromptTemplate.swift:18-24`
- **What:** User custom ideas and child profile attributes are directly interpolated into the AI generation prompt.
- **Why:** Susceptible to prompt injection attempts to bypass bedtime story narrative constraints.
- **Action:** Wrap user input inside structural XML tags with explicit model instructions to ignore override commands.
- **Severity:** High

### 6.5 Insecure HTTP Scheme Allowed for Remote Backend
- **Location:** `App/Services/Supabase/SupabaseConfiguration.swift:55`
- **What:** `isConfigured` accepts plain `http` URLs for remote Supabase endpoints.
- **Why:** Transmits API keys in HTTP headers across unencrypted channels.
- **Action:** Allow `http://` exclusively for local testing on `localhost` or `127.0.0.1`.
- **Severity:** Medium

### 6.6 Missing Explicit AI Safety Settings for Child Readers
- **Location:** `App/Services/AI/GeminiRequestMapper.swift:11-16`
- **What:** AI request payload does not declare explicit Gemini `safetySettings`.
- **Why:** Default API safety filters may not meet strict age 3–12 children's content requirements.
- **Action:** Include explicit `safetySettings` with `BLOCK_LOW_AND_ABOVE` thresholds across all standard harm categories.
- **Severity:** Medium

### 6.7 Children's Privacy (COPPA) Missing Parental Gate
- **Location:** `App/Features/Settings/StoryProfileSettingsContent.swift:9-24`
- **What:** Child nickname, age, and interests can be edited and connected to external AI without a parental challenge.
- **Why:** Violates Apple App Store Review Guideline 1.3 for Kids Category applications.
- **Action:** Implement a Parental Gate modal before allowing access to Settings and external AI configurations.
- **Severity:** Medium

### 6.8 Redundant Keychain Update/Insert Loop
- **Location:** `App/Services/Security/SecureAPIKeyStore.swift:68-77`
- **What:** `updateOrInsert` passes `kSecAttrAccessible` in `SecItemUpdate`, which is unsupported on certain iOS versions.
- **Why:** Can lead to unexpected parameter errors when saving credentials.
- **Action:** Standardize on atomic delete-then-add logic.
- **Severity:** Low

---

## 7. Performance

_No findings._ Illustration rendering utilizes NukeUI with aggressive caching and downsampling.

---

## 8. SwiftUI / UI

_No findings._ View tree follows atomic decomposition without heavy body evaluations.

---

## 9. Dead code / duplication / refactor

### 9.1 Files to delete outright
_No findings._ Codebase is compact and well-maintained.

---

## 10. Cross-cutting recommendations

1. **Centralize Inbound URL Security**: Validate and confirm all deep links through a dedicated `DeepLinkSecurityCoordinator` before mutating global state.
2. **Standardize Keychain for All Credentials**: Unify Gemini API keys and user-supplied Supabase keys under `SecureAPIKeyStore`.
3. **Defense-in-Depth for Children's Safety**: Combine client-side prompt delimiters with strict server-side AI safety settings.

---

## 11. What was NOT audited

- Third-party dependency internals (`Nuke`, `NukeUI`).
- Visual animation physics math in `CurvedPageMetrics.swift`.
- Supabase cloud server infrastructure and physical database configuration.

---

## 12. Verification

- **§6.1** — open `App/ContentView.swift`, lines `82-96`. Inspect `handleIncomingURL` immediately applying `SupabaseConfiguration` changes and clearing cache without confirmation.
- **§6.2** — open `App/Features/Stories/Components/StoryImageLoader.swift`, lines `25-29`. Verify non-HTTP string passed directly to `illustrationURL`.
- **§6.3** — open `App/Services/Supabase/SupabaseConfiguration.swift`, lines `32-44`. Verify `anonKey` read and written directly to `UserDefaults.standard`.
- **§6.4** — open `App/Services/AI/StoryPromptTemplate.swift`, lines `18-24`. Inspect direct string interpolation of `context.ideaText`.
- **§6.5** — open `App/Services/Supabase/SupabaseConfiguration.swift`, line `55`. Verify `["http", "https"].contains(scheme)` allows arbitrary remote HTTP.
- **§6.6** — open `App/Services/AI/GeminiRequestMapper.swift`, lines `11-16`. Verify absence of `safetySettings` field.
