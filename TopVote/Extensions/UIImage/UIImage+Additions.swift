//
//  UIImage+Blurr.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// A convenience function for creating a UIImage from UIView.
    ///
    /// - Parameters:
    ///   - theView: The view to snapshot.
    ///   - size: the size of the image should be created with.
    ///   - afterScreenUpdates: should the snapshot wait after screen has updated.
    /// - Returns: returns a snapshot from UIImage.
    
    class func imageFromView(_ theView: UIView, withSize size: CGSize, afterScreenUpdates: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // -renderInContext: renders in the coordinate space of the layer,
        // so we must first apply the layer's geometry to the graphics context
        context.saveGState()
        // Center the context around the window's anchor point
        context.translateBy(x: size.width/2, y: size.height/2)
        // Apply the window's transform about the anchor point
        context.concatenate(theView.transform)
        // Offset by the portion of the bounds left of and above the anchor point
        context.translateBy(x: -(theView.bounds.size.width * theView.layer.anchorPoint.x),
                            y: -(theView.bounds.size.height * theView.layer.anchorPoint.y))
        
        theView.drawHierarchy(in: theView.bounds, afterScreenUpdates: afterScreenUpdates)
        
        // Restore the context
        context.restoreGState()
        
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return theImage
    }
    
    // MARK: * Color Image
    
    /// A convenience function for coloring UIImages.
    ///
    /// - Parameter color: the color used for the image.
    /// - Returns: the image colored.
    
    func with(_ color: UIColor) -> UIImage {
        guard let cgImage = self.cgImage else {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: imageRect, mask: cgImage)
        color.setFill()
        context.fill(imageRect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImageOrientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
