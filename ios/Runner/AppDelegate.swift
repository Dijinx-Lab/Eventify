import UIKit
import GoogleMaps
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let filePath = Bundle.main.path(forResource: "Config", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: filePath),
       let apiKey = plist["GOOGLE_MAPS_KEY"] as? String {
      GMSServices.provideAPIKey(apiKey)
    } else {
      print("API Key not found in Config.plist")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
