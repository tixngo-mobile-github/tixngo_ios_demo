//
//  EmbeddedViewController.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 20/12/2023.
//

import UIKit
import sdk

class EmbeddedViewController: UIViewController {
    var containerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addTIXNGOView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("Navigation => EmbeddedViewController")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.addTIXNGOView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeTIXNGOView()
    }
    
    func addTIXNGOView() {
        if (containerView == nil) {
            containerView = UIView()
            containerView?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView!)
            NSLayoutConstraint.activate([
                containerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                containerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                containerView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                containerView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            ])
            
            // add child view controller view to container
            let controller = TixngoManager.instance.getHomePage()
            addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            containerView!.addSubview(controller.view)
            
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: containerView!.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor)
            ])
            
            controller.didMove(toParent: self)
        }
    }
    
    func removeTIXNGOView() {
        containerView?.removeFromSuperview()
        containerView = nil
    }
}
