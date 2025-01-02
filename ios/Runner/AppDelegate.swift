import Flutter
import SwiftUI

class AppDelegate: FlutterAppDelegate, MultiEngineApi, ObservableObject {
    let flutterEngine = FlutterEngine(name: "my flutter engine")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Runs the default Dart entrypoint with a default Flutter route.
            flutterEngine.run();
            // Used to connect plugins (only if you have plugins with iOS platform code).
            GeneratedPluginRegistrant.register(with: self.flutterEngine);
            MultiEngineApiSetup.setUp(binaryMessenger: self.flutterEngine.binaryMessenger, api: self)
            return true;
        }
    
    func spawnEngine(name: String) throws {
        let newEngine = FlutterEngine(name: name)
        newEngine.run(withEntrypoint: "secondaryEntry", libraryURI: nil, initialRoute: nil, entrypointArgs: [name])
        
        let flutterViewController = FlutterViewController(
            engine: newEngine,
            nibName: nil,
            bundle: nil)
        
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController?.presentedViewController
        else { return }
        
        rootViewController.present(flutterViewController, animated: true)
    }
    
    func pushFlutter() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }
        
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil)
        
        rootViewController.present(flutterViewController, animated: true)
    }
}

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appDelegate)
        }
    }
}
