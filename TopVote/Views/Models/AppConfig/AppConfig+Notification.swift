//
//  AppConfig+Notification.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

// MARK: - AppConfig / Notifications
extension NSNotification.Name {
    
    /// Notification for when a App Config object is updated.
    
    public static let AppConfigUpdated = NSNotification.Name(rawValue: "AppConfigUpdated")
}
