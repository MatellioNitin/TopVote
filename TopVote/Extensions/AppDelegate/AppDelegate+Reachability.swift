//
//  AppDelegate+Reachability.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

extension NSNotification.Name {
    /// Internet disconnect notification, called on disconnect.
    
    public static let InternetDisconnected = NSNotification.Name(rawValue: "InternetDisconnectedNotification")
    
    /// Internet connect notification. called on successful connection.
    
    public static let InternetConnected = NSNotification.Name(rawValue: "InternetConnectedNotification")
}

/// Extend App Delegate for handling Internet Reachability specific tasks.

extension AppDelegate {
    // MARK: * Reachability
    
    /// Register for Internet connectivity changes, connected or disconnected.
    
    func registerReachability() {
        guard let reachability = reachability else {
            return
        }
        
        // Reachability (Internet Connection).
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged),
                                               name: NSNotification.Name.ReachabilityChangedNotification,
                                               object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch { }
    }
    
    /// Handles Internet Connection State changes
    ///
    /// - Parameter note: The notification recieved from ReachabilityChangedNotification.
    
    @objc fileprivate func reachabilityChanged(note: NSNotification) {
        guard let reachability = note.object as? Reachability else {
            return
        }
        
        DispatchQueue.main.async {
            if reachability.isReachable {
                self.internetAccessView.hide()
                NotificationCenter.default.post(name: NSNotification.Name.InternetConnected,
                                                object: nil)
            } else {
                self.internetAccessView.show()
                NotificationCenter.default.post(name: NSNotification.Name.InternetDisconnected,
                                                object: nil)
            }
        }
    }
}
