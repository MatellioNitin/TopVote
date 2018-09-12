//
//  UIView+Additions.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// Additional properties for uiview accessable in uistoryboard.

extension UIView {
    
    /// Corner radius of view. defaults nil.
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// border width of view. defaults nil.
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// border color of view. defaults nil.
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /// Shadow color of view. defaults nil.
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
            if layer.shadowColor != nil {
                layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            }
        }
    }
    
    /// shadow opacity of view. defaults nil.
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// the offset for the shadow applied. defaults nil.
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// The radius of the shadow applied. defaults nil.
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// should the view be rasterized. defaults false.
    
    @IBInspectable
    var shouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = newValue
        }
    }
    
    /// should the view mask to bounds. defaults false.
    
    @IBInspectable
    var isMasksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    /// Add drop shadow to view
    
    func dropShadow(_ rect: CGRect? = nil, _ shadowOffset: CGSize = CGSize(width: -1, height: 1), _ shadowRadius: CGFloat = 3.0, _ shadowOpacity: Float = 0.5, _ shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        let frame = rect ?? self.bounds
        //layer.shadowPath = UIBezierPath(rect: frame).cgPath
        layer.shadowPath = UIBezierPath(roundedRect: frame, cornerRadius: layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
