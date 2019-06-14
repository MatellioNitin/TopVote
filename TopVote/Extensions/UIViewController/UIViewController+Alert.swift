//
//  UIViewController+Alert.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// A convenience function for showing UIAlerts in view controller.
    ///
    /// - Parameters:
    ///   - title: The title of the alert. defaults to `Attention`.
    ///   - confirmTitle: the confirmation message. defaults to `OK`
    ///   - errorMessage: the error message to show to the user.
    ///   - actions: the UIAlertActions that should also be used by the alertview.
    ///   - confirmCompletion: the confirmation action completion handler, called when confirmation action is selected.
    ///   - completion: the completion handler called when the alert is finished being presented.
    
    func showAlert(title: String = "Attention",
                   confirmTitle: String = "OK",
                   errorMessage: String,
                   actions: [UIAlertAction]? = nil,
                   confirmCompletion: (() -> Void)? = nil,
                   completion: (() -> Void)? = nil)
    {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
            
            if let actions = actions {
                for action in actions {
                    alertController.addAction(action)
                }
            }
            
            let okAction = UIAlertAction(title: confirmTitle, style: .default, handler: { (_) in
                confirmCompletion?()
            })
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: {
                completion?()
            })
        }
    }
    
    func showErrorAlert(title:String = "Oops!", errorMessage: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: {
                completion?()
            })
        }
    }
}
