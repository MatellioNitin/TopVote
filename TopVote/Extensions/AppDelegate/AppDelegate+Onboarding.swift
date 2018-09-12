//
//  UIApplication+OnBoarding.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// Extend App Delegate for handling Onboarding specific tasks.

extension AppDelegate {
    // MARK: * Onboarding
    
    /// Shows Onboarding Navigation Flow. Presents `OnboardingRootViewController`
    ///
    /// - Parameters:
    ///   - animated: should the presentation of `OnboardingRootViewController` to be animated.
    ///   - completion: The completion handler called after `OnboardingRootViewController` has been presented.
    
    func showOnboardingViewController(animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        if !isOnboardingShowing {
            let onboardingNavigationController = OnboardingRootViewController.createNavigationController()
                onboardingNavigationController.modalPresentationStyle = .overCurrentContext
                onboardingNavigationController.modalPresentationCapturesStatusBarAppearance = true
            
                DispatchQueue.main.async {
                    self.window?.rootViewController?.present(onboardingNavigationController, animated: animated, completion: {
                        completion?()
                    })
                }
        } else {
            completion?()
        }
    }
    
    /// Dismisses Onboarding Navigation.
    ///
    /// - Parameters:
    ///   - animated: should the dismissal of the visible `Onboarding` Controller be animated.
    ///   - completion: The completion handler called after `OnboardingRootViewController` has been dismissed.
    
    func dismissOnboardingViewController(_ animated: Bool = false, completion: (() -> Swift.Void)? = nil) {
        if isOnboardingShowing {
            DispatchQueue.main.async {
                self.window?.rootViewController?.dismiss(animated: animated, completion: { 
                    completion?()
                })
            }
        } else {
            completion?()
        }
    }
    
    /// Check if any of the Onboarding controllers is visble/currently presented.
    
    var isOnboardingShowing: Bool {
        guard let controller = (window?.rootViewController?.visibleViewController as? UINavigationController)?.topViewController
            ?? window?.rootViewController?.visibleViewController else {
            return false
        }
        
        return controller.className.contains("Onboarding")
    }
}
