//
//  ConfirmSignupViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit

class ConfirmSignupViewController: UIViewController {
    @IBOutlet weak var codeTextField: UITextField!
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
        AwsCognitoService.instance!.confirmSignUp(username, code: code, completion: { error in
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
