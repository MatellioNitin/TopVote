//
//  NSObject+Additions.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// Base vars and functions used throughout application.

extension NSObject {
    
    /// the name of the class.
    
    var className: String {
        return type(of: self).className
    }
    
    /// the name of the class
    
    @nonobjc static var className: String {
        return String(describing: self)
    }
    
    /// Returns a nib if one exists for the class. The nib must be the same name as the class name.
    ///
    /// - Returns: UINib for class name.
    
    static func nib() -> UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
}
