//
//  UINavigationController+Additions.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension MFMailComposeViewController {
    
    /// Override so the viewcontroller can set the status bar style for MFMailComposeViewController.
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    /// Override so the viewcontroller can set the status bar style for MFMailComposeViewController.

    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return nil
    }
}

extension UINavigationController {

    /// Override so the viewcontroller can set the status bar style.

    open override var childViewControllerForStatusBarHidden: UIViewController? {
        if var topViewController = self.viewControllers.first {
            if let navigationController = topViewController as? UINavigationController {
                topViewController = navigationController.viewControllers.last!
            }
            return topViewController
        }
        
        return super.childViewControllerForStatusBarHidden
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.viewControllers.last
    }
}
