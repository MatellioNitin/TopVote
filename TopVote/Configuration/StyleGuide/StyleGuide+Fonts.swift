//
//  StyleGuide+Fonts.swift
//  //  iOS Foundation
//
//  Created by Luke McDonald on 8/26/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

import UIKit

extension StyleGuide {
    struct Font {
        enum CreteRound {
            case regular, italic
            
            var name: String {
                switch self {
                case .regular:
                    return "CreteRound-Regular"
                case .italic:
                    return "CreteRound-Italic"
                }
            }
            
            var fontFamily: String {
                return "Crete Round"
            }
            
            var fontNames: [String] {
                return ["CreteRound-Italic", "CreteRound-Regular"]
            }
        }
        
        enum OpenSans {
            case regular, italic, bold, lightItalic, semiBoldItalic, extraBoldItalic, boldItalic, light, semiBold, extraBold
            
            var name: String {
                switch self {
                case .regular:
                    return "OpenSans"
                case .italic:
                    return "OpenSans-Italic"
                case .bold:
                    return "OpenSans-Bold"
                case .lightItalic:
                    return "OpenSansLight-Italic"
                case .semiBoldItalic:
                    return "OpenSans-SemiboldItalic"
                case .extraBoldItalic:
                    return "OpenSans-ExtraboldItalic"
                case .boldItalic:
                    return "OpenSans-BoldItalic"
                case .light:
                    return "OpenSans-Light"
                case .semiBold:
                    return "OpenSans-Semibold"
                case .extraBold:
                    return "OpenSans-Extrabold"
                }
            }
            
            var fontFamily: String {
                return "Open Sans"
            }
            
            var fontNames: [String] {
                return ["OpenSansLight-Italic", "OpenSans-Bold", "OpenSans-SemiboldItalic", "OpenSans-ExtraboldItalic", "OpenSans-BoldItalic", "OpenSans-Light", "OpenSans-Semibold", "OpenSans", "OpenSans-Italic", "OpenSans-Extrabold"]
            }
        }
    }
    
    static func styleFont( _ type: Font.CreteRound, _ pointSize: CGFloat) -> UIFont {
        return UIFont(name: type.name, size: pointSize) ?? UIFont.systemFont(ofSize: pointSize)
    }
    
    static func styleFont( _ type: Font.OpenSans, _ pointSize: CGFloat) -> UIFont {
        return UIFont(name: type.name, size: pointSize) ?? UIFont.systemFont(ofSize: pointSize)
    }
}
