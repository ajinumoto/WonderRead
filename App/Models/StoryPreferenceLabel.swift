import Foundation

enum StoryPreferenceLabel {
  static func localized(_ storedValue: String) -> String {
    switch storedValue {
    case "Hangat": String(localized: "Warm and comforting")
    case "Penuh imajinasi": String(localized: "Imaginative")
    case "Lucu": String(localized: "Funny")
    case "Petualangan": String(localized: "Adventure")
    case "Fantasi": String(localized: "Fantasy")
    case "Kehidupan sehari-hari": String(localized: "Everyday life")
    case "Berani mencoba": String(localized: "Courage to try")
    case "Saling menolong": String(localized: "Helping one another")
    case "Rasa ingin tahu": String(localized: "Curiosity")
    default: storedValue
    }
  }
}
