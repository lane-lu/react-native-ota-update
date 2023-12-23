import Foundation
import UIKit

struct Application: Decodable {
  var name: String?
  var packages: [Package] = []
  
  enum CodingKeys: String, CodingKey {
    case name
    case packages
  }
}
