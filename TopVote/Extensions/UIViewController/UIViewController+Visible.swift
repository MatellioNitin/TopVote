//
//  UIViewController+Visible.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// The current visible view controller in application.
    
    var visibleViewController: UIViewController? {
        if presentedViewController == nil {
            return self
        }
        
        if let presented = presentedViewController {
            if presented is UINavigationController {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last
            }
            
            if presented is UITabBarController {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController
            }
            
            return presented.visibleViewController
        }
        
        return nil
    }
}
