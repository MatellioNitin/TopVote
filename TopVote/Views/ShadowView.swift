//
//  ShadowView.swift
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    // MARK: * Properties
    
    @IBInspectable var shadowCol: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    @IBInspectable var shadowRad: CGFloat = 2.0
    
    @IBInspectable var cornerRad: CGFloat = 2.0
    
    @IBInspectable var fillCol: UIColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    
    @IBInspectable var strokeCol: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    @IBInspectable var shadOffset: CGSize = CGSize(width: 0.0, height: 0.0)
    
    /// Only override draw() if you perform custom drawing.
    /// An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let ref = UIGraphicsGetCurrentContext() else {
            return
        }
        
        /* We can only draw inside our view, so we need to inset the actual 'rounded content' */
        let contentRect = rect.insetBy(dx: 0, dy: 0)
        
        /* Create the rounded path and fill it */
        let roundedPath = UIBezierPath(roundedRect: contentRect, cornerRadius: cornerRad)
        ref.setFillColor(fillCol.cgColor)
        ref.setShadow(offset: shadOffset, blur: shadowRad, color: shadowCol.cgColor)
        roundedPath.fill()
        
        /* Draw a subtle white line at the top of the view */
        roundedPath.addClip()
        
        ref.setStrokeColor(strokeCol.cgColor)
        ref.setBlendMode(.overlay)
        
        ref.move(to: CGPoint(x: contentRect.minX, y: contentRect.minY + 0.5))
        ref.addLine(to: CGPoint(x: contentRect.maxX, y: contentRect.minY + 0.5))
        
        ref.strokePath()
    }
}
