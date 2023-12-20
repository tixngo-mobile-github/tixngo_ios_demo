//
//  SignupViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit
import AWSCognitoIdentityProvider

class SignupViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backgroundTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let spiner = SpinnerViewController()
        spiner.show(self)
        let username = userNameTextField.text!
        let password = passwordTextField.text!
        AwsCognitoService.instance!.signup(username, password: password) { (error, _) in
            if error == nil {
                self.performSegue(withIdentifier: appSegue.confirmSignup.rawValue, sender: username)
            } else {
                UIAlertController.show(self, title: "Error", message: error!.localizedDescription)
            }
            spiner.hide()
        }
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmSignupViewController
        vc.set(username: sender as! String)
    }
}
