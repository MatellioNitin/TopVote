//
//  AppDelegate+AppConfig.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

/// Extend App Delegate for handling App Configuration specific tasks.

extension AppDelegate {
    // MARK: * Configuration Timer
    
    /// Function is called from configurationTimer for making requests against api.
    
    func handleAppConfigurationTimer() {
        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            self?.requestAppConfiguration()
        }
    }
    
    /// Makes a request to api for App Configuration
    ///
    /// - Parameter completion: The completion Handler called on request completed. returns true or false if error occured.
    
    func requestAppConfiguration(completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { /*[weak self]*/ () -> Void in
//            AppConfig.config(error: { (_) in
//                DispatchQueue.main.async {
//                    completion?(false)
//                }
//            }) { [weak self] (configuration) in
//                self?.appConfig = configuration
//                DispatchQueue.main.async {
//                    completion?(true)
//                }
//            }
        }
    }
}
