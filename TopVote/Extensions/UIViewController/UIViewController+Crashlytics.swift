//
//  UIViewController+Crashlytics.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit
// import Crashlytics

extension UIViewController {
    
    /// A convenience function for handling sending reports to Crashlytics.
    /// View will appear is swizzled.
    ///
    /// - Parameter animated: the animated state of uiviewcontroller.
    
    func crashReport_viewWillAppear(_ animated: Bool) {
        /*if !(self is UINavigationController) && !(self is UITabBarController) && !(self is UIPageViewController) {
            // Report UI Actions throughout application, save ourselves from boilerplate code.
            Crashlytics.sharedInstance().setObjectValue(self.className, forKey: "last_UI_action")
        }*/
    }
}
