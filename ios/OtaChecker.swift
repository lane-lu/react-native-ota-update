import Foundation

public class OtaChecker {
  let serverURL: URL
  let resolve: RCTPromiseResolveBlock
  let reject: RCTPromiseRejectBlock
  
  init(serverURL: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    self.serverURL = URL(string: serverURL)!
    self.resolve = resolve
    self.reject = reject
  }
  
  func checkUpdate() -> Void {
    URLSession.shared.dataTask(with: serverURL) {data, response, error in
      if let data {
        do {
          let decoder = JSONDecoder()
          let app = try decoder.decode(Application.self, from: data)
          //print("app: \(app)")

          var array = []
          for pkg in app.packages {
            let element: [AnyHashable: Any?] = [
              "version": pkg.version,
              "description": pkg.description,
              "timestamp": pkg.timestamp,
              "type": pkg.type,
              "download_url": pkg.downloadURL
            ]
            array.append(element)
          }
          self.resolve(array)
        } catch {
          //print(error)
          self.reject("E_CHECKUPDATE", "error when check udpate", error)
        }
      }
    }.resume()
  }
}
