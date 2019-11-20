//
//  Account+Notification.swift
//  iOS Foundation
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

// MARK: - Accounts / Notifications
extension NSNotification.Name {
    
    public static let AccountRefreshed = NSNotification.Name(rawValue: "AccountRefreshedNotification")

    /// Notification for when a account object is created.
    
    public static let AccountCreated = NSNotification.Name(rawValue: "AccountCreatedNotification")
    
    /// Notification for when a account session has expired.
    
    public static let AccountSessionExpired = NSNotification.Name(rawValue: "AccountSessionExpiredNotification")
    
    /// Called when a user logs out of there account.
    
    public static let AccountLoggedOut = NSNotification.Name(rawValue: "AccountLoggedOutNotification")
    
    /// Called when a user account is locked.
    
    public static let AccountLocked = NSNotification.Name(rawValue: "AccountLockedNotification")
}
