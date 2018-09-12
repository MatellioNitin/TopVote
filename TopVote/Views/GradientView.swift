//
//  GradientView.swift
//  TopVote
//
//  Created by Kurt Jensen on 5/11/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class GradientView: UIView {

    @IBInspectable var colorOne = Style.tintColor
    @IBInspectable var colorTwo = Style.barTintColor
    
    let gradientLayer = CAGradientLayer()
    
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
        refresh()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func refresh() {
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        refresh()
    }

}
