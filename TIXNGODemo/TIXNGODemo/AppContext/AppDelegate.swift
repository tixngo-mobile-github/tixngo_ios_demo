//
//  AppDelegate.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 23/08/2022.
//

import UIKit
import Flutter
import sdk
import native_font

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.configFont()
        self.configApns(application)
        self.configAwsCognito()
        self.configTixngoSDK()
        
        return true
    }
    
    private func configFont() {
        NativeFontPlugin.fontDataHandler = {familyName, weight, isItalic, callback in
            if (familyName == "Qatar2022") {
                var fileName: String = "Qatar2022-Regular.otf"
                if (weight == FlutterFontWeight.weight700) {
                    fileName = "Qatar2022-Bold.otf"
                } else if (weight == FlutterFontWeight.weight500) {
                    fileName = "Qatar2022-Medium.otf"
                }
                
                let data = NSData(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: nil)!)) as? Data
                callback(data)
                return
            }
            
            callback(nil)
        }
    }
    
    private func configApns(_ application: UIApplication) {
        FirebaseService.shared.initialize(application)
    }
    
    private func configAwsCognito() {
        AwsCognitoService.instance = AwsCognitoService.init(region: .EUWest1, clientId: "69g6etb9kiendmj04gombdpnib", poolId: "eu-west-1_wNu7WMfPC")
    }
    
    private func configTixngoSDK() {
        let theme = TixngoTheme(font: "Qatar2022", colors: TixngoColor(primary: UIColor(rgb: 0x00968D), secondary: UIColor(rgb: 0x2B5B6C)))
        let config = TixngoConfiguration(licenseKey: "remove_later",
                                   isEnableDebug: true,
                                         defaultEnv: TixngoEnv.val,
                                   isEnableWallet: false,
                                   isCheckAppStatus: false,
                                         supportLanguages: [TixngoLanguages.en, TixngoLanguages.fr],
                                   defaultLanguage: TixngoLanguages.en,
                                   theme: theme,
                                         appId: "io.tixngo.app.sdk")
        TixngoManager.instance.initialize(config: config) { isAuthenticated in
            NotificationCenter.default.post(name: .authNotification, object: isAuthenticated)
        } onTokenExpiredHandler: {result in
            let shouldRetryOnTokenExpired = false
            result(shouldRetryOnTokenExpired)
        } onGetJwtTokenHandler: { result in
            AwsCognitoService.instance!.getToken { error, token in
                result(token)
            }
        } onGetDeviceTokenHandler: {result in
            FirebaseService.shared.getFcmToken { deviceToken in
                result(deviceToken)
            }
        } onCloseHandler: {
            NotificationCenter.default.post(name: .closeNotification, object: nil)
        }
        
        TixngoManager.instance.setEnv(.val)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        FirebaseService.shared.didReceiveRemoteNotification(userInfo, completionHandler: completionHandler)
    }
}

