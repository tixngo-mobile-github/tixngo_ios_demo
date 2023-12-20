//
//  ForgotPasswordViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        let spiner = SpinnerViewController()
        spiner.show(self)
        let username = usernameTextField.text!
        AwsCognitoService.instance!.forgotPassword(username) { (error, _) in
            if error == nil {
                self.performSegue(withIdentifier: appSegue.confirmForgotPw.rawValue, sender: username)
            } else {
                UIAlertController.show(self, title: "Error", message: error!.localizedDescription)
            }
            spiner.hide()
        }
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmForgotPassViewController
        vc.set(username: sender as! String)
    }
}
