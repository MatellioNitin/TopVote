//
//  StyleGuide.swift
//  //  iOS Foundation
//
//  Created by Luke McDonald on 8/26/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// The Style Guide holds all variables for how the app should be displayed, custom fonts, colors, images(that are reused) used throughout application. The style guide also contains convenience functions for creating styled text, fonts, colors.

struct StyleGuide {
    static let statusBarStyle: UIStatusBarStyle = .lightContent
    
    /// style the application navbars, tabbars, uinavigationbar button items according to the creatives/mocks/design of application.
    
    static func styleApplication() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        let shadowBarImage = UIImage()
        
        let toolBarAppearance = UIToolbar.appearance()
        toolBarAppearance.barTintColor = Color.navigationBar
        
        let baseNavigationControllerAppearance = UINavigationBar.appearance()
        baseNavigationControllerAppearance.shadowImage = shadowBarImage
        baseNavigationControllerAppearance.setBackgroundImage(shadowBarImage, for: .default)
        baseNavigationControllerAppearance.isTranslucent = false
        baseNavigationControllerAppearance.barTintColor = Color.navigationBar
        baseNavigationControllerAppearance.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        baseNavigationControllerAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)]
        
        let barButtonItemTitleFont = UIFont.systemFont(ofSize: 18.0)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                                             NSAttributedStringKey.font: barButtonItemTitleFont],
                                                            for: .normal)
    }
    
    /// retrieves a list of available fonts available in application, see custom font installation for ios/xcode.
    
    static func showAvailableFonts() {
        print("")
        for name in UIFont.familyNames {
            print(name)
            print(UIFont.fontNames(forFamilyName: name))
        }
        print("")
    }
    
    // MARK: * NSAttributedString
    
    /// Formats a string for different display styles.
    /// One word may contain a different font, color, spacing from the rest the text displayed
    /// attributtedText is a convenience function for creating custom strings for display.
    ///
    /// - Parameters:
    ///   - text: the text to style.
    ///   - font: the font the text should use.
    ///   - textColor: the color of the text.
    
    /// - Returns: a NSAttributedString with the specified parameters.
    
    static func attributtedText(text: String, font: UIFont, textColor: UIColor) -> NSAttributedString {
        let attributed = NSAttributedString(string: text,
                                            attributes:[NSAttributedStringKey.font: font,
                                                        NSAttributedStringKey.foregroundColor: textColor])
        return attributed
    }
    
    /// Formats a string for different display styles.
    /// One word may contain a different font, color, spacing from the rest the text displayed
    /// attributtedMutableText is a convenience function for creating custom strings for display.
    ///
    /// NSMutableAttributedString can append other NSMutableAttributedStrings.
    /// mutableAttributedString1.append(mutableAttributedString2)
    ///
    /// - Parameters:
    ///   - text: the text to style.
    ///   - font: the font the text should use.
    ///   - textColor: the color of the text.
    ///   - paragraphStyle: the layout of the text, left/right aligned, spacing ect.
    /// - Returns: a NSMutableAttributedString with the specified parameters.
    
//    static func attributtedMutableText(text: String, font: UIFont, textColor: UIColor, paragraphStyle: NSMutableParagraphStyle? = nil) -> NSMutableAttributedString {
//        var attrs: [String : Any] = [NSFontAttributeName: font,
//                                     NSForegroundColorAttributeName: textColor]
//
//        if let style = paragraphStyle {
//            attrs[NSParagraphStyleAttributeName] = style
//        }
//
//        let attributed = NSMutableAttributedString(string: text,
//                                                   attributes: attrs)
//
//        return attributed
//    }
    
    /// Formats a string for different display styles.
    /// One word may contain a different font, color, spacing from the rest the text displayed
    /// attributtedMutableText is a convenience function for creating custom strings for display.
    ///
    /// NSMutableAttributedString can append other NSMutableAttributedStrings.
    /// mutableAttributedString1.append(mutableAttributedString2)
    ///
    /// - Parameters:
    ///   - image: the image to set within text.
    ///   - text: the text to style.
    ///   - textColor: the color of the text.
    ///   - font: the font the text should use.
    /// - Returns: a NSMutableAttributedString with the specified parameters.
    
    static func attributtedText(WithImageInText image: UIImage, text: String, textColor: UIColor, font: UIFont) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        let offsetY: CGFloat = -2.0
        let offsetX: CGFloat = 2.0
        
        attachment.bounds = CGRect(x: offsetX, y: offsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableString = NSMutableAttributedString(string: text + " ", attributes: [NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.font: font])
        mutableString.append(attachmentString)
        return mutableString
    }
    
    /// Convenience function for creating an CAGradientLayer
    
    static func styleGradient(_ rect: CGRect, _ locationsColors: [NSNumber: UIColor] = [0.0: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), 1.0: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        
        var gradientColors = [CGColor]()
        var gradientLocations = [NSNumber]()
        
        for (location, color) in locationsColors {
            let colorRef = color.cgColor as CGColor
            gradientColors.append(colorRef)
            gradientLocations.append(location)
        }
        
        gradientLayer.locations = gradientLocations
        gradientLayer.colors = gradientColors
        
        return gradientLayer
    }
}
