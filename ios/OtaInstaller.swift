import Foundation
import Zip

public class OtaInstaller: NSObject {
  let package: Package
  let resolve: RCTPromiseResolveBlock
  let reject: RCTPromiseRejectBlock
  
  init(package: Package, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    self.package = package
    self.resolve = resolve
    self.reject = reject
  }
  
  func install() -> Void {
    print("Install package, URL: \(package.downloadURL!)")
    let codePushPath = getDocumentsDirectory().appendingPathComponent("CodePush")
    let packagePath = codePushPath.appendingPathComponent(package.version!)
    
    do {
      if FileManager.default.fileExists(atPath: packagePath.path) {
        try FileManager.default.removeItem(at: packagePath)
      }
      try FileManager.default.createDirectory(at: packagePath, withIntermediateDirectories: true)
      print("Create package path: \(packagePath)")
    } catch {
      print(error)
      reject("E_INSTALLPACKAGE", "error when create package directory", error)
    }
    
    let zipPath = packagePath.appendingPathComponent("download.zip")
    let url: URL = URL(string: package.downloadURL!)!
    URLSession.shared.dataTask(with: url) {data, response, error in
      if let data {
        do {
          // Save zip file
          try data.write(to: zipPath)
          print("Download file, size: \(data.count)")
          
          // Unzip
          try Zip.unzipFile(zipPath, destination: packagePath, overwrite: true, password: nil)
          print("Unzip to directory: \(packagePath)")
          
          // Install main.jsbundle
          let bundle = self.search(name: "main.jsbundle", inDirectory: packagePath)
          if let bundle = bundle {
            print("bundle: \(bundle)")
            try FileManager.default.copyItem(at: bundle, to: packagePath.appendingPathComponent("main.jsbundle"))
          }
          let assets = self.search(name: "assets", inDirectory: packagePath)
          if let assets = assets {
            print("assets: \(assets)")
            try FileManager.default.moveItem(at: assets, to: packagePath.appendingPathComponent("assets"))
          }
          
          // Delete unzip file
          try FileManager.default.removeItem(at: zipPath)
          
          // Mark this bundle
          let exist = FileManager.default.fileExists(atPath: packagePath.appendingPathComponent("main.jsbundle").path)
          if exist, let version = self.package.version {
            UserDefaults.standard.set(version, forKey: "x-main-jsbundle-version")
            self.resolve(version)
          } else {
            UserDefaults.standard.removeObject(forKey: "x-main-jsbundle-version")
            self.reject("E_INSTALLPACKAGE", "error when search jsbundle", error)
          }
        } catch {
          self.reject("E_INSTALLPACKAGE", "error when download package", error)
        }
      }
    }.resume()
  }
  
  func install( toPath: URL) {
    
  }
  
  func search(name: String, inDirectory directory: URL) -> URL? {
    do {
      let array = try FileManager.default.contentsOfDirectory(atPath: directory.path)
      for fileName in array {
        if fileName == name {
          return directory.appendingPathComponent(fileName)
        } else {
          var isDir: ObjCBool = true
          let fullPath = "\(directory.path)/\(fileName)"
          if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
            if isDir.boolValue {
              if let url = search(name: name, inDirectory: directory.appendingPathComponent(fileName)) {
                return url
              }
            }
          }
        }
      }
    } catch {
      print("error when search main.jsbundle")
    }
    return nil
  }
  
  func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
  }
}
