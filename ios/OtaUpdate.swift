@objc(OtaUpdate)
class OtaUpdate: NSObject {
  
  @objc(checkUpdate:withTypes:withResolver:withRejecter:)
  func checkUpdate(options: NSDictionary, types: NSArray, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    guard let serverURL = options["serverURL"] as? NSString else {
      fatalError("OtaUpdate needs a serverURL.")
    }
    
    let checker = OtaChecker(serverURL: serverURL as String, resolve: resolve, reject: reject)
    checker.checkUpdate()
  }

  @objc(installPackage:withResolver:withRejecter:)
  func installPackage(package: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let version = package["version"] as? NSString
    let description = package["description"] as? NSString
    let timestamp = package["timestamp"] as? NSNumber
    let downloadURL = package["download_url"] as? NSString
    
    var pkg = Package()
    if let version = version {
      pkg.version = version as String
    }
    if let description = description {
      pkg.description = description as String
    }
    if let timestamp = timestamp {
      pkg.timestamp = timestamp.doubleValue
    }
    if let downloadURL = downloadURL {
      pkg.downloadURL = downloadURL as String
    }
    
    let installer = OtaInstaller(package: pkg, resolve: resolve, reject: reject)
    installer.install()
  }

  @objc(getConfiguration:withRejecter:)
  func getConfiguration(resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
  }

  @objc(restartApp:withRejecter:)
  func restartApp(resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
    print("restartApp")
    resolve(["action": "restartApp"])
  }

  @objc(clearUpdates:withRejecter:)
  func clearUpdates(resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
    UserDefaults.standard.removeObject(forKey: "x-main-jsbundle-version")
    resolve(["action": "clearUpdates"])
  }

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
}
