//
//  UIAlertController+extension.swift
//  TestPullCocoaPod
//
//  Created by Le Minh Hiep on 26/08/2022.
//

import UIKit

extension UIAlertController {
    static func show(_ vc : UIViewController, title : String?, message : String?, close : String = "Close") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: close, style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ vc : UIViewController, title : String?, message : String?, close : String = "Close", action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: close, style: .cancel, handler: { (_) in
            action()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}


