import Foundation

struct Package : Decodable {
  var version: String?
  var description: String?
  var timestamp: Double?
  var type: String?
  var downloadURL: String?
  var dependencies: [Dependency] = []
  
  enum CodingKeys: String, CodingKey {
    case version
    case description
    case timestamp
    case type
    case downloadURL = "download_url"
    case dependencies
  }
}
