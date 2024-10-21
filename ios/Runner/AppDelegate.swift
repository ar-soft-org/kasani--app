import UIKit
import Flutter
import OneSignalFramework

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
    
        OneSignal.initialize("0b6de201-cba8-42b8-906c-9e2c3bf40a39", withLaunchOptions: launchOptions)
                OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
