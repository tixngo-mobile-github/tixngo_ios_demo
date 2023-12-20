//
//  ConfirmForgotPassViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit

class ConfirmForgotPassViewController: UIViewController {
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    private var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func set(username: String) {
        self.username = username
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let spiner = SpinnerViewController()
        spiner.show(self)
        let code = codeTextField.text!
        let password = passTextField.text!
        AwsCognitoService.instance!.confirmForgotPassword(username, code: code, password: password, completion: { error in
            if error == nil {
                UIAlertController.show(self, title: "Successful", message: "Please sign in", close: "OK") {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                UIAlertController.show(self, title: "Error", message: error!.localizedDescription)
            }
            spiner.hide()
        })
        self.view.endEditing(true)
    }
}
