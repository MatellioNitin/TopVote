//
//  UIView+Animation.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// Custom UIView animations.

extension UIView {
    
    /// A convenience for apply a pop/bubble animation to a UIView.
    ///
    /// - Parameter completion: the completion handler called upon animation completion.
    
    func attachBubblePopAnimation(_ completion: (() -> Swift.Void)? = nil) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            // Actions to be done after animation
            completion?()
        }
        
        // Animation Code
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        let scale1 = CATransform3DMakeScale(0.5, 0.5, 1)
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1)
        let scale3 = CATransform3DMakeScale(0.9, 0.9, 1)
        let scale4 = CATransform3DMakeScale(1.0, 1.0, 1)
        
        let frameValues: [NSValue] = [NSValue(caTransform3D: scale1),
                                      NSValue(caTransform3D: scale2),
                                      NSValue(caTransform3D: scale3),
                                      NSValue(caTransform3D: scale4)
        ]
        
        animation.values = frameValues
        
        let frameTimes: [NSNumber] = [ NSNumber(value: 0.0),
                                       NSNumber(value: 0.5),
                                       NSNumber(value: 0.9),
                                       NSNumber(value: 1.0)
        ]
        
        animation.keyTimes = frameTimes
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.2
        
        self.layer.add(animation, forKey: "popup")
        
        CATransaction.commit()
    }
    
    /// A convenience for apply a pop/bubble animation to a UIView.
    ///
    /// - Parameter completion: the completion handler called upon animation completion.
    
    func attachBubblePopAnimation2(_ completion: (() -> Swift.Void)? = nil) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            // Actions to be done after animation
            completion?()
        }
        
        // Animation Code
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        let scale1 = CATransform3DMakeScale(0.5, 0.5, 1)
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1)
        let scale3 = CATransform3DMakeScale(0.8, 0.8, 1)
        let scale4 = CATransform3DMakeScale(1.1, 1.1, 1)
        let scale5 = CATransform3DMakeScale(0.9, 0.9, 1)
        let scale6 = CATransform3DMakeScale(1.0, 1.0, 1)
                
        let frameValues: [NSValue] = [NSValue(caTransform3D: scale1),
                                      NSValue(caTransform3D: scale2),
                                      NSValue(caTransform3D: scale3),
                                      NSValue(caTransform3D: scale4),
                                      NSValue(caTransform3D: scale5),
                                      NSValue(caTransform3D: scale6)
        ]
        
        animation.values = frameValues
        
        let frameTimes: [NSNumber] = [ NSNumber(value: 0.0),
                                       NSNumber(value: 0.2),
                                       NSNumber(value: 0.5),
                                       NSNumber(value: 0.8),
                                       NSNumber(value: 0.9),
                                       NSNumber(value: 1.0)
        ]
        
        animation.keyTimes = frameTimes
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.35
        
        self.layer.add(animation, forKey: "popup")
        
        CATransaction.commit()
    }
}
