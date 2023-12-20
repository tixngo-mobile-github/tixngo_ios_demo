//
//  MainViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit
import sdk

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "TIXNGO views - present"
        registerNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("Navigation => MainViewController")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        deregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(forName: .closeNotification, object: nil, queue: OperationQueue.main) { notification in
            self.dismiss(animated: true)
        }
    }
    
    private func deregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: .closeNotification, object: nil)
    }
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let vc = TixngoManager.instance.getHomePage()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func myTicketButtonPressed(_ sender: Any) {
        let vc = TixngoManager.instance.getEventPage()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func transferredTicketButtonPressed(_ sender: Any) {
        let vc = TixngoManager.instance.getTransferredTicketPage()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pendingTicketButtonPressed(_ sender: Any) {
        let vc = TixngoManager.instance.getPendingTicketPage()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        TixngoManager.instance.signOut()
        NotificationCenter.default.post(name: .authNotification, object: false)
    }
}
