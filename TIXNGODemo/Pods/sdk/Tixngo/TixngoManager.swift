import Flutter
import UIKit

public class TixngoManager {
    public static let instance = TixngoManager()
        
    private let sdk: TixngoSdk
    
    // ----- Request: Native --> Sdk -----//
    private let openHomePage = "sdk.open_home_page"
    private let openEventPage = "sdk.open_my_event_page"
    private let openTransferredPage = "sdk.open_transferred_ticket_page"
    private let openPendingPage = "sdk.open_pending_ticket_page"
    private let doSetProfile = "sdk.set_profile"
    private let doSetEnv = "sdk.set_environment"
    private let doSignOut = "sdk.do_sign_out"
    private let doSignIn = "sdk.do_sign_in"
    private let getAuthStatus = "sdk.get_auth_status"
    private let processPushMessage = "sdk.process_push_message"
    private let processPushDeviceToken = "sdk.process_push_device_token"
    private let getConfigs = "getConfigs"
    
    // ----- Request: Sdk --> Native -----//
    private let onTokenExpired = "sdk.on_token_expired"
    private let onCloseButton = "sdk.on_close_button_pressed"
    private let onGetJwtToken = "sdk.get_jwt_token"
    private let onGetDeviceToken = "sdk.get_device_token"
    private let onInitialized = "sdk.initialized"
    private let onDebug = "sdk.debug"
    
    private init() {
        sdk = TixngoSdk.init()
    }
    
    /*
     Call this method to initialize SDK, and received isAuthenticated status in onInitializedHandler
     + onInitializedHandler: SDK return isAuthenticated to app
     + onTokenExpiredHandler: SDK request shouldRetry from app, if true, app should refresh token in advance
     + onGetJwtTokenHandler: SDK request jwtToken from app, it will be called whenever sdk request data from backend and during initialization
     + onGetDeviceTokenHandler: SDK request fcmDeviceToken from app
     + onCloseHandler: SDK notify app that user tap close button, app should close SDK UI and return to app UI
    */
    public final func initialize(
        config: TixngoConfiguration?,
        onInitializedHandler: @escaping ((_ isAuthenticated: Bool) -> Void),
        onTokenExpiredHandler: @escaping ((@escaping (_ shouldRetry: Bool) -> Void) -> Void),
        onGetJwtTokenHandler: @escaping ((@escaping (_ jwtToken: String?) -> Void) -> Void),
        onGetDeviceTokenHandler: @escaping ((@escaping (_ deviceToken: String?) -> Void) -> Void),
        onCloseHandler: @escaping () -> Void
    ) {
        
        sdk.initialize { (call, result) in
            let method = call.method
            let args = call.arguments
            if method == self.onInitialized {
                onInitializedHandler(args as! Bool)
                result(nil)
            } else if method == self.onGetJwtToken {
                onGetJwtTokenHandler { jwtToken in
                    result(jwtToken)
                }
            } else if method == self.onTokenExpired {
                onTokenExpiredHandler{ shouldRetry in
                    result(shouldRetry)
                }
            } else if method == self.onGetDeviceToken {
                onGetDeviceTokenHandler { deviceToken in
                    result(deviceToken)
                }
            } else if method == self.onCloseButton {
                onCloseHandler()
                result(nil)
            } else if method == self.onDebug {
                print("Debug log \(String(describing: args!))")
                result(nil)
            } else if method == self.getConfigs {
                self.configTixngo(with: config, result: result)
            } else {
                print("Method \(method) - Arguments \(String(describing: args))")
                result(nil)
            }
        }
    }
    
    private func configTixngo(with config: TixngoConfiguration?, result: FlutterResult) {
        result(config?.json ?? TixngoConfiguration.default.json)
    }
    
    /*
     Call this method to sign in sdk, it must be called after the app finishes signin and get profile
     + completion: error == nil -> success
    */
    public func signIn(_ profile: TixngoProfile, completion: @escaping ((_ error: String?) -> Void)) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSignIn, arguments: profile.toJson()) { error in
                completion(error as? String)
            }
        }
    }
    
    /*
     Call this method to sign out sdk when user do signout in app
    */
    public func signOut() {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSignOut, arguments: nil)
        }
    }
    
    /*
     Call this method to set profile to sdk when user profile is changed in app
    */
    public func setProfile(_ profile: TixngoProfile, completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSetProfile, arguments: profile.toJson()) { _ in
                completion()
            }
        }
    }
    
    /*
     Get authentication status of sdk, when call this method, sdk will ask jwt token from app. If jwt is nil, sdk will always sent false
    */
    public func getAuthStatus(_ completion: @escaping ((_ isAuthenticated: Bool) -> Void)) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.getAuthStatus, arguments: nil) { isAuthenticated in
                completion(isAuthenticated as! Bool)
            }
        }
    }
    
    /*
     Call this method to send push notification to sdk
    */
    public func processFcmMessageIfNeed(_ message: [String: Any]) {
        DispatchQueue.main.async {
            if let noti = TixngoPushNotification.init(message) {
                self.sdk.sendMessage(self.processPushMessage, arguments: noti.toJson())
            }
        }
    }
    
    /*
     Call this method to send Firebase device token to sdk
    */
    public func processFcmTokenIfNeed(_ deviceToken: String?) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.processPushDeviceToken, arguments: deviceToken)
        }
    }
    
    /*
     Set environment of sdk
    */
    public final func setEnv(_ env: TixngoEnv) {
        DispatchQueue.main.async {
            self.sdk.sendMessage(self.doSetEnv, arguments: env.rawValue)
        }
    }
    
    public func getCurrentPage() -> UIViewController {
        return sdk.rootViewController
    }
    
    public func getHomePage()  -> UIViewController {
        sdk.sendMessage(openHomePage, arguments: nil)
        return sdk.rootViewController
    }
    
    public func getEventPage() -> UIViewController {
        sdk.sendMessage(openEventPage, arguments: nil)
        return sdk.rootViewController
    }
    
    public func getTransferredTicketPage() -> UIViewController {
        sdk.sendMessage(openTransferredPage, arguments: nil)
        return sdk.rootViewController
    }
    
    public func getPendingTicketPage() -> UIViewController {
        sdk.sendMessage(openPendingPage, arguments: nil)
        return sdk.rootViewController
    }
}
