import Flutter
import SwiftUI

class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "my flutter engine")
    var flutterViewController: FlutterViewController?
    init() {
        prewarm()
    }

    func prewarm() {
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
    }

    func presentFlutter() {
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
        flutterViewController.modalPresentationStyle = .pageSheet
        flutterViewController.isViewOpaque = false

        rootViewController.present(flutterViewController, animated: false)
    }

    func showFlutter() {
        if let flutterViewController {
            flutterViewController.removeFromParent()
            flutterViewController.view.removeFromSuperview()
            self.flutterViewController = nil
            return
        }
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }

        flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil)
        guard let flutterViewController else { return }
        flutterViewController.isViewOpaque = false

        rootViewController.addChild(flutterViewController)
        rootViewController.view.addSubview(flutterViewController.view)

        flutterViewController.didMove(toParent: rootViewController)
        flutterViewController.view.frame = .init(x: 0, y: 0, width: 200, height: 400)
    }
}

@main
struct MyApp: App {
    @StateObject var flutterDependencies = FlutterDependencies()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(flutterDependencies)
        }
    }
}
