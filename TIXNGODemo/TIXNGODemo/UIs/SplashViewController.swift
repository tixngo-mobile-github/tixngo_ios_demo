//
//  SplashViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit

enum appSegue: String {
    case main = "mainSegue"
    case login = "loginSegue"
    case confirmForgotPw = "confirmForgotPasswordSegue"
    case confirmSignup = "confirmSignUpSegue"
}

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotifications()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        deregisterNotification()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(forName: .authNotification, object: nil, queue: .main) { [weak self] notification in
            guard let `self` = self, let isAuthenticated = notification.object else { return }
            self.dismiss(animated: false) {
                if (isAuthenticated as? Bool ?? false) {
                    self.performSegue(withIdentifier: appSegue.main.rawValue, sender: nil)
                } else {
                    self.performSegue(withIdentifier: appSegue.login.rawValue, sender: nil)
                }
            }
        }
    }
    
    private func deregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: .authNotification, object: nil)
    }
}
