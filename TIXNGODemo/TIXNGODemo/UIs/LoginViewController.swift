//
//  LoginViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit
import sdk
import SwiftRandom

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotifications()
    }
    
    deinit {
        self.deregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(forName: .closeNotification, object: nil, queue: .main) {[weak self] notification in
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func deregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: .closeNotification, object: nil)
    }

    @IBAction func backgroundTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        self.view.endEditing(true)
        UIAlertController.show(self, title: "Note!!!", message: "Firstname, lastname, gender and date of birth are randomly because we don't store user-info in AWS Cognito", close: "Continue") {
            let spiner = SpinnerViewController()
            spiner.show(self)
            AwsCognitoService.instance!.login(username, password: password) { error, token in
                if error == nil {
                    // Randomly user information - In real case, please get profile in SSO
                    let fullname = Randoms.randomFakeName().components(separatedBy: " ")
                    let firstName = fullname.first!
                    let lastName = fullname.last!
                    let gender = Randoms.randomBool() ? TixngoGender.male : TixngoGender.female
                    let dob = Randoms.randomDateWithinDaysBeforeToday(365 * 20)
                    
//                    let profile = ProfileModel(firstName: firstName,
//                                               lastName: lastName,
//                                               gender: gender,
//                                               dateOfBirth: dob,
//                                               email: username)
                    
                    let profile = TixngoProfile.init(firstName: firstName,
                                                     lastName: lastName,
                                                     gender: gender,
                                                     face: nil,
                                                     dateOfBirth: dob,
                                                     nationality: nil,
                                                     passportNumber: nil,
                                                     idCardNumber: nil,
                                                     email: username,
                                                     phoneNumber: nil,
                                                     address: nil,
                                                     birthCity: nil,
                                                     birthCountry: nil,
                                                     residenceCountry: nil)
                    TixngoManager.instance.signIn(profile) { error in
                        if error == nil {
                            NotificationCenter.default.post(name: .authNotification, object: true)
                        } else {
                            UIAlertController.show(self, title: "Error", message: error!)
                        }
                        spiner.hide()
                    }
                } else {
                    UIAlertController.show(self, title: "Error", message: error!.localizedDescription)
                    spiner.hide()
                }
            }
        }
    }
    
    @IBAction func openSDKUIButtonPressed(_ sender: Any) {
        let vc = TixngoManager.instance.getCurrentPage()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
