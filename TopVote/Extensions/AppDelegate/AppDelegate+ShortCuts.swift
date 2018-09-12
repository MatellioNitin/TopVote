//
//  AppDelegate+ShortCuts.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

// MARK: - AppDelegate / UIApplicationShortcuts
extension AppDelegate {
    
    /// Handles the available short cuts if device is capable of force touch.

    enum ShortCut {
        
        /// short cut is unknown to the system.
        
        case unknown
        
        /// the selected index for the short cut item.
        
        var selectedIndex: Int {
            switch self {
            default:
                return -1
            }
        }
        
        /// A Convenience initializer for short cuts
        ///
        /// - Parameter identifier: the short cut identifier.
        
        init(identifier: String) {
            switch identifier {
            default:
                self = .unknown
                break
            }
        }
    }
    
    /// performs action when short cut item exists.
    ///
    /// - Parameter shortcutItem: the item to execute.
    /// - Returns: true or false if the action can be performed.
    
    func handleShortcut( shortcutItem: UIApplicationShortcutItem) -> Bool {
        let succeeded = false
        let shortcut: ShortCut = ShortCut(identifier: shortcutItem.type)
        let selectedIndex = shortcut.selectedIndex
        
        if selectedIndex > -1 {
          
        }
        
        return succeeded
    }
}
