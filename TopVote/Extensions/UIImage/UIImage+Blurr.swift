//
//  UIImage+Blurr.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIImage {
    
    /// A convenience function for blurring a UIImage
    ///
    /// - Parameters:
    ///   - radius: the radius of the blurr
    ///   - iterations: how many times should the image be blurred more iterations requires more cpu.
    ///   - tintColor: the tint color to apply to the blurred image.
    /// - Returns: blurred image from parameters specified.
    
    func blurredImageWithRadius(_ radius: CGFloat, iterations: NSInteger, tintColor: UIColor) -> UIImage {
        if floorf(Float(size.width)) * floorf(Float(size.height)) <= 0.0 {
            //image must be nonzero size
            return self
        }
        
        //boxsize must be an odd integer
        var boxSize: UInt32 = UInt32(radius * self.scale)
        if boxSize % 2 == 0 {
            boxSize += 1
        }
        
        //create image buffers
        var imageRef: CGImage = self.cgImage!
        var buffer1: vImage_Buffer = vImage_Buffer()
        var buffer2: vImage_Buffer = vImage_Buffer()
        
        let height: vImagePixelCount = vImagePixelCount(imageRef.height)
        let width: vImagePixelCount = vImagePixelCount(imageRef.width)
        
        buffer1.width = width
        buffer2.width = width
        
        buffer1.height = height
        buffer2.height = height
        
        buffer1.rowBytes = imageRef.bytesPerRow
        buffer2.rowBytes = imageRef.bytesPerRow
        
        let bytes: size_t = (Int(buffer1.rowBytes) * Int(buffer1.height))
        buffer1.data = malloc(bytes)
        buffer2.data = malloc(bytes)
        
        //create temp buffer
        let tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, nil, 0, 0, boxSize, boxSize,
                                                           nil, UInt32(kvImageEdgeExtend) + UInt32(kvImageGetTempBufferSize)))
        
        //copy image data
        let dataSource: CFData = imageRef.dataProvider!.data!
        memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes)
        
        for _ in 0..<iterations {
            //perform blur
            vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, nil, UInt32(kvImageEdgeExtend))
            
            //swap buffers
            let temp = buffer1.data
            buffer1.data = buffer2.data
            buffer2.data = temp
        }
        
        //free buffers
        free(buffer2.data)
        free(tempBuffer)
        
        //create image context from buffer
        let ctx: CGContext = CGContext(data: buffer1.data, width: Int(buffer1.width), height: Int(buffer1.height),
                                       bitsPerComponent: 8, bytesPerRow: buffer1.rowBytes, space: imageRef.colorSpace!,
                                       bitmapInfo: imageRef.bitmapInfo.rawValue)!
        
        //apply tint
        if tintColor.cgColor.alpha > 0.0 {
            ctx.setFillColor(tintColor.withAlphaComponent(0.25).cgColor)
            ctx.setBlendMode(.plusLighter)
            ctx.fill(CGRect(x: 0, y: 0, width: CGFloat(buffer1.width), height: CGFloat(buffer1.height)))
        }
        
        //create image from context
        imageRef = ctx.makeImage()!
        let image = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        free(buffer1.data)
        return image
    }
}
