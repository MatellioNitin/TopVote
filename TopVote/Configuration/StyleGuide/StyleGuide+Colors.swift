//
//  StyleGuide+Colors.swift
//  //  iOS Foundation
//
//  Created by Luke McDonald on 8/26/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

extension StyleGuide {
    struct Color {
        static let navigationBar = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let viewColors: (primary: UIColor, secondary: UIColor) = (#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.9411764706, green: 0.9294117647, blue: 0.9098039216, alpha: 1))
        
        static let buttonPrimaryColors: (main: UIColor, border: UIColor, text: UIColor, textShadow: UIColor?)  = (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), nil)
        static let buttonDisabledColors: (main: UIColor, border: UIColor, text: UIColor, textShadow: UIColor?) = (UIColor.clear, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), nil)
        static let buttonSecondaryColors: (main: UIColor, border: UIColor, text: UIColor, textShadow: UIColor?) = (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), nil)
        static let buttonPasswordColors: (show: UIColor, hide: UIColor, showText: UIColor, hideText: UIColor) = (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        static let labelClickableWordColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        static let primaryTextColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    }
}
