//
//  String+Additions.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var first: String {
        return String(characters.prefix(1))
    }
    
    var last: String {
        return String(characters.suffix(1))
    }
  
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    /// Checks if the string is all Numeric value.
    
    var isNumeric: Bool {
        let nonDigitChars = CharacterSet.decimalDigits.inverted
        
        let string = self as NSString
        
        if string.rangeOfCharacter(from: nonDigitChars).location == NSNotFound {
            // definitely numeric entierly
            return true
        }
        
        return false
    }
    
    /// Checks if the string contains any white space.
    
    var containsWhiteSpace: Bool {
        // check if there's a range for a whitespace
        let whitespace = NSCharacterSet.whitespaces
        let range = rangeOfCharacter(from: whitespace)
        
        // returns false when there's no range for whitespace
        if range != nil {
            return true
        }
        
        return false
    }
    
    /// A convenience func for labels that constrains its width to the size of the text length and font.
    ///
    /// - Parameters:
    ///   - width: the width of label or max width allowed.
    ///   - font: the font used for the label.
    /// - Returns: Size that should be used by the label.
    
    func sizeWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.size
    }
}
