import Foundation

struct SelectedStoryFactors: Sendable {
  var setting: String
  var companion: String
  var mission: String
  var magicItem: String
  var weatherMood: String
  var kindAction: String

  var promptDescription: String {
    """
    - Tempat Petualangan: \(setting)
    - Sahabat Baru: \(companion)
    - Misi Seru: \(mission)
    - Benda Ajaib: \(magicItem)
    - Suasana & Cuaca: \(weatherMood)
    - Kunci Kebaikan: \(kindAction)
    """
  }
}
