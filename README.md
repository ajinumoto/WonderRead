# WonderRead

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0%20%7C%205.10-F05138?style=flat-square&logo=swift&logoColor=white)](https://developer.apple.com/swift/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-0071e3?style=flat-square&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS%20%7C%20macOS%20%7C%20iPhone%20Duo-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/)
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20On--Device%20%7C%20Zero%20Tracking-blue?style=flat-square)](LICENSE)
[![Open Source](https://img.shields.io/badge/Open%20Source-MIT-green?style=flat-square)](LICENSE)

<p align="center">
  <img src="Images/Home%20Screen.png" alt="WonderRead Children's Storybook Home & Shelf" width="680" style="max-width: 100%; height: auto; border-radius: 14px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);" />
</p>

**WonderRead** is a 100% open-source, distraction-free children's storybook application and AI bedtime storytelling companion built purely in **SwiftUI** for the Apple ecosystem.

Purpose-engineered specifically for **children's illustrated storybooks and cozy bedtime reading**, WonderRead gives children and parents two distinct ways to experience stories:
* 📚 **Curated Storybook Collections:** Read from thoughtfully curated shelves of children's literature, classic folklore, and timeless fables—or connect community shelves directly from the [WonderRead Repo Hub](https://wonder-read-hub.vercel.app/).
* ✨ **Personalized AI-Generated Bedtime Books:** Generate original, beautifully illustrated children's storybooks on demand where **your child is the protagonist and main character**, with the storyline, moral lessons, and story world dynamically tailored to their age and personal interests.

Combining the tactile joy of printed books with the creative wonder of generative AI, WonderRead delivers a bespoke reading experience crafted in strict adherence to **Apple Human Interface Guidelines (HIG)** and App Store **Kids Category Guidelines (Guideline 1.3 / COPPA)**.

<p align="center">
  <a href="Images/iPad%20Demo.mp4" title="Watch full resolution video demo">
    <img src="Images/iPad%20Demo.gif" alt="WonderRead Interactive iPad Storybook Reading Demo" width="680" style="max-width: 100%; height: auto; border-radius: 14px; box-shadow: 0 8px 24px rgba(0,0,0,0.12);" />
  </a>
  <br />
  <em>📖 Tap/click the preview above or <a href="Images/iPad%20Demo.mp4">watch the full resolution iPad Demo Video (<code>Images/iPad Demo.mp4</code>)</a>.</em>
</p>

---

### Highlights

* 🧒 **Designed Exclusively for Children's Stories:** Crafted specifically for young readers and bedtime routines, featuring warm eye-soothing paper palettes, scalable child-friendly typography, and comfortable one-handed controls for parents.
* 📚 **Curated Children's Book Shelves:** Explore hand-picked fables, folklore, and bedtime adventures—or discover and import community-curated collections from [WonderRead Repo Hub](https://wonder-read-hub.vercel.app/) via 1-click deep links with automatic offline caching.
* 🔒 **Parental Gate ("Grown-Ups Only"):** In strict compliance with **Apple App Store Guideline 1.3** and COPPA children's privacy standards, all sensitive areas (Settings, custom AI profile parameters, and external repository switching) are protected behind an interactive adult math verification challenge.
* 🌟 **Personalized AI Stories (Child as the Hero):** Automatically generate custom bedtime stories where **your child is the main character**, tailoring narrative plot, themes, moral virtues, and vocabulary level to their unique preferences.
* 🛡️ **Child-Safe AI Guardrails & Prompt Defense:** Enforces strict `BLOCK_LOW_AND_ABOVE` Google Gemini safety filters across all harm categories (harassment, hate speech, sexual content, dangerous content) and sanitizes custom idea inputs against prompt injection.
* 🍃 **Native Tactile UX & Foldable First (iPhone Duo):** Authentic 3D page-curl physics, dynamic spine crease illumination that organically reacts to physical hinge angles, paper grain textures, gentle haptic vibrations on page turns, and fluid dynamic layouts tailored for iPhone, iPad, macOS, and iPhone Duo.
* 📦 **Automatic Offline Reading:** Every book or chapter you open is automatically cached locally (`SupabaseStoryCache`), ensuring full offline availability on road trips, flights, or anywhere without an internet connection.
* 🔐 **Hardware Keychain Security:** Both your Google Gemini API key and Supabase anonymous key are encrypted directly inside Apple's Keychain (`SecureAPIKeyStore`). Privileged `service_role` master keys are automatically detected and rejected for database safety.
* 🌐 **100% Open Source:** Free, transparent, and openly licensed under the MIT License for families, developers, and educators. Zero tracking scripts, zero ads, and zero telemetry.

---

## Core Features

### Realistic 3D Page-Curl & Tactile UX

<p align="center">
  <img src="Images/iPad%20Read%20Screen.png" alt="WonderRead Tactile Book Spread on iPad" width="640" style="max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.12);" />
</p>

* **Curved Page Physics:** Mathematical leaf geometry simulates physical paper turning with reactive lighting, inner crease shadows, and authentic spine depth.
* **Gentle Haptic Feedback:** Tactile haptic impulses (`UIImpactFeedbackGenerator`) provide a subtle, satisfying click sensation with each page flip.
* **Fluid Multiplatform Gestures:** Interactive touch drags on iOS/iPadOS, smooth two-finger trackpad glides on macOS, and keyboard shortcut navigation (`Spacebar` / `Arrow Keys`).
* **Desktop Reading Experience on macOS:** Fully optimized wide layout with comfortable margins and high-resolution illustration rendering.

<p align="center">
  <img src="Images/Mac%20Read%20Screen.png" alt="WonderRead Desktop Experience on macOS" width="640" style="max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.12);" />
</p>

---

### Foldable Innovation: iPhone Duo Postures & Reactive Hinge Shadows

<p align="center">
  <a href="Images/Duo%20Demo.mp4" title="Watch full resolution iPhone Duo video demo">
    <img src="Images/Duo%20Demo.gif" alt="WonderRead iPhone Duo Foldable Demo" width="680" style="max-width: 100%; height: auto; border-radius: 14px; box-shadow: 0 8px 24px rgba(0,0,0,0.12);" />
  </a>
  <br />
  <em>📖 Tap/click the preview above or <a href="Images/Duo%20Demo.mp4">watch the full resolution iPhone Duo Demo Video (<code>Images/Duo Demo.mp4</code>)</a>.</em>
</p>

WonderRead is engineered from the ground up for Apple's foldable **iPhone Duo** (`iOS 27.1+`), optimizing every device posture with dynamic physics-based lighting:

* **Real-Time Reactive Hinge Shadows:** Spine crease shadow intensity calculates dynamically in real time based on the physical hinge angle (`StoryLayout.spineShadowIntensity(for:)`). As the device folds or opens, inner crease depth and paper illumination seamlessly adapt to the physical curvature of the book spread.
* **Full Multi-Posture Optimization (`DuoReaderPose`):**
  * 📖 **Inner Book Spread (`innerBook`):** Turns the inner dual display into an authentic, immersive two-page open storybook spread with zero fold clipping.
  * 🌙 **Bedside Tabletop Stand (`innerTable`):** Automatically reorients when placed angled on a bedside table, displaying colorful story illustrations on the angled upper display and comfortable reading text with touch controls on the flat bottom display.
  * 📱 **Outer Display Ergonomics (`outerPortrait` / `outerLandscape`):** Smoothly transitions into an ultra-portable single-page reader with bottom-anchored controls when closed or folded.
* **Zero Content Occlusion:** Natively respects `geometry.reservedRegions(kind: .division)` to ensure illustrations and story text never get cut off or obscured across the hinge fold.

---

### Mindful Bedtime Design & Child-Friendly Reading Comfort

<p align="center">
  <img src="Images/Night%20Mode.gif" alt="WonderRead Soothing Night Mode Animation" width="640" style="max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.12);" />
</p>

<p align="center">
  <img src="Images/iPad%20Read%20Screen%20Portrait.png" alt="WonderRead on iPad Portrait" width="280" style="max-width: 48%; height: auto; border-radius: 10px; vertical-align: middle;" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="Images/iPhone%20Read%20Screen.png" alt="WonderRead on iPhone" width="200" style="max-width: 45%; height: auto; border-radius: 10px; vertical-align: middle;" />
</p>

* **Eye-Soothing Bedtime Palette & Night Mode:** Specially balanced paper cream and warm amber tints (`StoryPalette`) minimize blue-light exposure in dark bedrooms (see animated night mode above).
* **Child-Friendly Typography:** Scalable serif typography with dynamic text sizing designed for early readers and parent read-aloud sessions across both portrait and landscape orientations.
* **One-Handed Bedtime Ergonomics:** Bottom-anchored controls let parents comfortably turn pages and adjust text size while holding a sleeping child.
* **Zero-Lag Visual Pipeline:** Powered by [NukeUI](https://github.com/kean/Nuke) for lightning-fast, memory-efficient illustration decoding.

---

### Curated Storybook Collections & Community Hub

<p align="center">
  <img src="Images/Collection%20Settings%20Screen.png" alt="Curated Collection Settings" width="310" style="max-width: 48%; height: auto; border-radius: 10px; vertical-align: middle;" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="Images/History%20List%20Screen.png" alt="Reading History & Progress Tracker" width="310" style="max-width: 48%; height: auto; border-radius: 10px; vertical-align: middle;" />
</p>

* **Hand-Picked Children's Classics:** Starter shelf featuring classic fables, moral folklore, and bedtime adventures available in English and Bahasa Indonesia, curated for wholesome reading.
* **Explore Community Collections on WonderRead Hub:** Discover new story collections curated by families, schools, and authors at **[wonder-read-hub.vercel.app](https://wonder-read-hub.vercel.app/)**.
* **1-Click Safe Deep Link Import:** Tap **Install App** on any collection on the Hub to import via `wonderread://install-repo`. An explicit parental confirmation alert prevents accidental repository switching or cache disruption.
* **Instant Offline Availability:** Any storybook or chapter opened in the app is automatically cached locally on your device—ready to read anytime, anywhere without cellular data or Wi-Fi.
* **Reading Progress Memory & History Tracker:** Automatically bookmarks chapter progress and tracks finished stories in a dedicated history shelf (`History List Screen`).

---

### Personalized AI Story Generation: The Child as the Main Character

<p align="center">
  <img src="Images/Ai%20Settings%20Screen.png" alt="AI Story Customization & Child Preferences" width="560" style="max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.12);" />
</p>

* **Your Child is the Protagonist:** Every generated story casts your child by name as the central hero, creating an empowering and intimate bedtime experience where they star in their own adventures.
* **Tailored Narrative Plot & Preferences:** The narrative arc, story world, and vocabulary are dynamically crafted based on your child's age, favorite interests (e.g., animals, space, mythical creatures), and storytelling style (customizable directly in `AI Settings`).
* **Embedded Moral Values:** Meaningful life lessons (such as kindness, honesty, perseverance, and empathy) are woven naturally into the plot through the child's choices and actions rather than overt preaching.
* **Complete Standalone Illustrated Chapters:** Generates complete, self-contained bedtime stories (400–700 words) with scene-setting illustration prompts, ensuring a satisfying bedtime journey every night.
* **Dual AI Engine (On-Device & Gemini BYOK):** Run private on-device local models or connect to Google Gemini using your personal API key (Gemini 3.8 Flash, 3.7 Flash, 3.6 Flash).
* **Luminous Shimmer Feedback:** Playful animated shimmer sweeps entertain young readers while new chapters are penned in real time.

---

### Children's Privacy, Security & Parental Gate (Apple Guideline 1.3)

* **Parental Verification Gate:** Before opening Settings, accessing child profile settings, or switching repository backends, a randomized arithmetic challenge (*"Grown-Ups Only"*) must be solved, preventing young children from accidentally modifying configuration or navigating outside the app.
* **Child-Safe AI Guardrails:** Built-in Gemini safety settings strictly block harmful, sexually explicit, hateful, or dangerous content at the lowest possible sensitivity threshold (`BLOCK_LOW_AND_ABOVE`).
* **Hardware Keychain Storage:** Sensitive API keys (Google Gemini and Supabase anonymous key) are secured in Apple Keychain, never saved in unencrypted property lists or user defaults.

---

## Under the Hood: Architecture & Craft

WonderRead is engineered using clean, modern Apple platform standards:

* **Pure SwiftUI (No-ViewModel):** Employs SwiftUI's native state primitives (`@State`, `@Observable`, and `@Environment`) to avoid unnecessary abstraction layers and eliminate state-synchronization bugs.
* **Dual State Machine:** Clean architectural boundary between transient interactive animation states (`ViewState`) and persistent domain logic.
* **Pure Data Mappers:** Network payloads, prompt blueprints, and view models are translated via testable, side-effect-free pure mapper functions.
* **Swift 6 Strict Concurrency:** Fully compliant with Swift 6 concurrency invariants, actor isolation, and thread safety.
* **Minimal Footprint:** No heavy third-party framework trees; relies purely on native Apple APIs and NukeUI for image decoding.

<p align="center">
  <img src="Images/AppIcon.png" alt="WonderRead Icon" width="96" style="border-radius: 22px;" />
</p>

---

## Getting Started

### Prerequisites

* macOS 15.0 (Sequoia) or later
* Xcode 16.0 or later (Tested on Xcode 27.1 / Swift 6.2)
* Deployment Target: iOS 18.0+ / macOS 15.0+

### Clone & Open

```bash
git clone https://github.com/ajinumoto/Lentera.git WonderRead
cd WonderRead
open WonderRead.xcodeproj
```

*(Note: The project can also be regenerated from scratch using `xcodegen generate --spec Project.json`).*

### Supabase Setup (Using Your Own Collection)

WonderRead includes a ready-to-run SQL schema blueprint:

1. Create a project at [supabase.com](https://supabase.com) (or use your self-hosted instance).
2. Open the **SQL Editor** in your Supabase project dashboard.
3. Paste and run the script from [`supabase_schema.sql`](supabase_schema.sql).
4. Connect credentials in WonderRead:
   * **Via 1-Click Web Deep Link (Recommended):** Browse community collections on the **[WonderRead Repo Hub](https://wonder-read-hub.vercel.app/)** and tap **Install App**. The app launches automatically via `wonderread://install-repo` and prompts for confirmation.
   * **In the app:** Open **Settings > Supabase** (accessible after completing the Parental Gate), then enter your Project URL and Public Anon Key manually.
   * **Via build config:** Define `SUPABASE_PROJECT_URL` and `SUPABASE_ANON_KEY` in `Config/Debug.xcconfig`.

#### Deep Link Repository Import Specification

Community directories and third-party web catalogs can trigger instant in-app repository switching using the `wonderread://` URL scheme:

```uri
wonderread://install-repo?url=<SUPABASE_PROJECT_URL>&key=<ANON_KEY>&name=<COLLECTION_NAME>
```

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `url` | URL-encoded string | **Yes** | Fully qualified HTTPS Supabase project URL (e.g., `https://xyz.supabase.co`). |
| `key` | String | **Yes** | Public Supabase Anonymous Key (`anonKey`). Private `service_role` keys are rejected. |
| `name` | URL-encoded string | No | Human-readable collection display name for the in-app confirmation prompt. |

### Google Gemini Setup (Bring Your Own Key)

To enable custom AI story generation:

1. Generate a free API key at [Google AI Studio](https://aistudio.google.com/).
2. In WonderRead, navigate to **Settings > AI Settings** (protected by Parental Gate).
3. Enter and save your Gemini API key (it is securely encrypted in Apple's Keychain).
4. The app defaults to **Gemini 3.8 Flash**, with a curated in-app picker for supported models (Gemini 3.8 Flash, 3.7 Flash, 3.6 Flash).

---

## Running Tests

WonderRead includes unit and integration tests verifying prompt builders, data mappers, and reading history trackers:

```bash
# Run tests directly in Xcode:
Product -> Test (Cmd + U)
```

---

## Contributing

Contributions from the open-source community are warmly welcomed!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feat/YourFeature`)
3. Commit your Changes (`git commit -m 'feat: Add YourFeature'`)
4. Push to the Branch (`git push origin feat/YourFeature`)
5. Open a Pull Request

---

## Legal Disclaimer & Third-Party Content

> [!IMPORTANT]
> **Independent Client Application & Content Separation:**
> 
> * **Software Only:** WonderRead is strictly an open-source, client-side storybook reading engine and user-interface application. WonderRead does not host, store, index, distribute, or own any story texts, illustrations, audio, or third-party intellectual property.
> * **Not Part of the Application:** Any story collections, custom repositories, Supabase backends, JSON manifests, or shortcodes installed, connected, or imported by users are maintained, hosted, and operated entirely by independent third parties or by the users themselves. They do not constitute part of the WonderRead application or source code.
> * **Community Hub:** [WonderRead Repo Hub](https://wonder-read-hub.vercel.app/) is a community-driven repository directory. Connecting an external Supabase repository or importing collections is an elective action performed solely at the user's discretion. Users are responsible for ensuring that any collections or databases they connect adhere to applicable local copyright laws and intellectual property rights.
> * **Trademarks & Intellectual Property:** All character names, trademarks, book titles, and copyrighted materials belong strictly to their respective owners. Mention or linkage of sample schemas or community repositories is provided solely for technical interoperability and educational purposes, without endorsement or affiliation.

---

## License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

<p align="center">
  Crafted with care for bedtime dreamers and little readers everywhere. 📖✨
</p>
