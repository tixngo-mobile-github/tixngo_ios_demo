//
//  FirebaseService.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseMessaging
import sdk

class FirebaseService: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    static let shared = FirebaseService()
    
    func initialize(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    func getFcmToken(_ completion: @escaping (_ deviceToken: String?) -> Void) {
        Messaging.messaging().token { deviceToken, error in
            completion(deviceToken)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        TixngoManager.instance.processFcmTokenIfNeed(fcmToken)
    }
    
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let userInfo = userInfo as? [String: Any] {
            TixngoManager.instance.processFcmMessageIfNeed(userInfo)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                  -> Void) {
        let userInfo = notification.request.content.userInfo
        if let userInfo = userInfo as? [String: Any] {
            TixngoManager.instance.processFcmMessageIfNeed(userInfo)
        }
        completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let userInfo = userInfo as? [String: Any] {
            TixngoManager.instance.processFcmMessageIfNeed(userInfo)
        }
        completionHandler()
    }
}
