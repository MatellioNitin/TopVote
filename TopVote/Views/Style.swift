//
//  Style.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import Foundation
import UIKit

class Style {

    static var tintColor = UIColor.white {
        didSet {
            UITabBar.appearance().tintColor = UIColor(hex: "#5F2B74")
            UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "#5F2B74")
            UINavigationBar.appearance().barTintColor = tintColor
        }
    }
    static var barTintColor = UIColor.black {
        didSet {
            UINavigationBar.appearance().barTintColor = barTintColor
            //UIView.appearance().tintColor = tintColor
        }
    }
    
    static var fontName = "Roboto-Regular" {
        didSet {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: Style.fontBoldWithSize(21), NSAttributedStringKey.foregroundColor: UIColor.white]
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Style.fontWithSize(10)], for: UIControlState())
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Style.fontWithSize(12)], for: UIControlState())
        }
    }
    static var fontBoldName = "Roboto-Bold" {
        didSet {
        }
    }
    static var fontItalicName = "Roboto-Italic" {
        didSet {
        }
    }
    
    class Color {
        static let instagramColor = UIColor(hex: "#458eff")
        static let facebookColor = UIColor(hex: "#3b5998")
        static let twitterColor = UIColor(hex: "#4099FF")
    }
    
    class func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: Style.fontName, size: size)!
    }
    
    class func fontBoldWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: Style.fontBoldName, size: size)!
    }
    
    class func fontItalicWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: Style.fontItalicName, size: size)!
    }
    
    class func setup() {
        Style.tintColor = UIColor(hex: "#D0AC31")
        Style.barTintColor = UIColor(hex: "#5F2B74")
        Style.fontName = "Avenir-Medium"
        Style.fontBoldName = "Avenir-Heavy"
        Style.fontItalicName = "Roboto-Italic"
    }
    
}

class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
}

class CircleImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = min(bounds.width, bounds.height)/2.0
        layer.masksToBounds = true
    }
    
}

class TVButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if let titleLabel = titleLabel {
            let isBold = 0 != (titleLabel.font.fontDescriptor.symbolicTraits.rawValue & (UIFontDescriptorSymbolicTraits.traitBold).rawValue)
            if (isBold) {
                titleLabel.font = Style.fontBoldWithSize(titleLabel.font.pointSize)
            } else {
                titleLabel.font = Style.fontWithSize(titleLabel.font.pointSize)
            }
        }
    }
    
}

class ShadowButton: TVButton {
    
    override func setup() {
        super.setup()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0,height: 2)
    }
    
}

class SocialButton: TVButton {
    
    override func setup() {
        super.setup()
        layer.cornerRadius = 5
    }
    
}

class RoundedButton: TVButton {

    override func setup() {
        super.setup()
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = titleLabel?.textColor.cgColor
    }
    
}

class RoundedTextField: TVTextField {
    
    override func setup() {
        super.setup()
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = UIColor.black.cgColor
    }
    
}

class TVTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if let font = font {
            let isBold = 0 != (font.fontDescriptor.symbolicTraits.rawValue & (UIFontDescriptorSymbolicTraits.traitBold).rawValue)
            if (isBold) {
                self.font = Style.fontBoldWithSize(font.pointSize)
            } else {
                self.font = Style.fontWithSize(font.pointSize)
            }
        }
    }
}

class RoundedTextView: TVTextView {
    
    override func setup() {
        super.setup()
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = UIColor.black.cgColor
    }
    
}

class TVTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if let font = font {
            let isBold = 0 != (font.fontDescriptor.symbolicTraits.rawValue & (UIFontDescriptorSymbolicTraits.traitBold).rawValue)
            if (isBold) {
                self.font = Style.fontBoldWithSize(font.pointSize)
            } else {
                self.font = Style.fontWithSize(font.pointSize)
            }
        }
    }
}

class TVLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        let isBold = 0 != (font.fontDescriptor.symbolicTraits.rawValue & (UIFontDescriptorSymbolicTraits.traitBold).rawValue)
        if (isBold) {
            font = Style.fontBoldWithSize(font.pointSize)
        } else {
            font = Style.fontWithSize(font.pointSize)
        }
    }
}

class BarView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        backgroundColor = #colorLiteral(red: 0.9688202739, green: 0.9690397382, blue: 0.9751045108, alpha: 1)
    }
}


class TVAlertController: UIAlertController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.tintColor = Style.barTintColor
    }
    
}

//class TabBarController: UITabBarController {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setup()
//    }
//
//    func setup() {
//        for i in 0..<childViewControllers.count {
//            self.selectedIndex = i
//        }
//        self.selectedIndex = 0
//    }
//
//}

extension UIColor {
    
    convenience init(hex: String) {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        let a: CGFloat = 1
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = hex.substring(from: start)
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255
                }
            }
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
