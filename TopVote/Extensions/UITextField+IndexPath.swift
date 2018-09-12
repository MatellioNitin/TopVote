//
//  UITextField+IndexPath.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/7/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// the indexPath key for retainment.
private var indexPathAssociationKey: UInt8 = 0

extension UITextField {
    /// The index path for text field contained within a cell.
    
    var indexPath: IndexPath? {
        get {
            return (objc_getAssociatedObject(self, &indexPathAssociationKey) as? IndexPath)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &indexPathAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
