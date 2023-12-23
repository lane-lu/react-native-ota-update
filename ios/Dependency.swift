import Foundation

struct Dependency: Decodable {
  var name: String?
  var versionRange: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case versionRange = "version_range"
  }
}
