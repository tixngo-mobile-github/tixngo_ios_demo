import Flutter
import UIKit
import FlutterPluginRegistrant

class TixngoSdk {

    private let flutterEngine = FlutterEngine(name: "engine")

    private let channel: FlutterMethodChannel

    private var _rootViewController: FlutterViewController

    var rootViewController: UIViewController {
        get {
            return _rootViewController
        }
    }

    init() {
        channel = FlutterMethodChannel(name: "io.tixngo.sdk", binaryMessenger: flutterEngine.binaryMessenger)
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        _rootViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    }


    func initialize(_ handler: @escaping FlutterMethodCallHandler) {
        channel.setMethodCallHandler(handler)
    }

    func sendMessage(_ method: String, arguments: Any?, result: FlutterResult? = nil) {
        refreshIfNeed()
        channel.invokeMethod(method, arguments: arguments, result: result)
    }

    private func refreshIfNeed() {
        _rootViewController.removeFromParent()
        flutterEngine.viewController = nil
        _rootViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    }
}

