//
//  CustomUITextField.swift
//  Softaps
//
//  Created by Anuj on 23/07/18.
//  Copyright © 2018 CGT. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {
    var placeHolderLabel:UILabel = UILabel()
    // screen dimention
   
    @IBInspectable open var fontSize : CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        // add border
        self.borderColor = textFieldInactiveColor
        self.borderWidth = 1.0
        self.clipsToBounds = true
      //  addOutterPlaceHolder()
        self.backgroundColor = UIColor.clear
    }
    
    //MARK:- functions For FontSize
    override func awakeFromNib() {
        super.awakeFromNib()
        let fontSizeAccordingToScreen = (self.font?.pointSize)! * scrWidthRation
        self.font = self.font?.withSize(fontSizeAccordingToScreen)
        self.borderColor = textFieldInactiveColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:- IBInspectable
    @IBInspectable var textFieldActiveColor: UIColor = kColor.textFieldActive {
        didSet {
            self.activeTextFiled()
        }
    }
    
    @IBInspectable var textFieldInactiveColor: UIColor = kColor.textFieldInActive {
        didSet {
           self.inActiveTextFiled()
        }
    }
    
    @IBInspectable var leftImage: UIImage = UIImage(named: "emptyImage")! {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftimageLeading: CGFloat = 0
    @IBInspectable var leftimageTrailing: CGFloat = 0
    
    @IBInspectable var leftimageWidth: CGFloat = 15 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var leftimageHeight: CGFloat = 20 {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var leftImagecolor: UIColor = kColor.textFieldInActive {
        didSet {
            leftView?.tintColor = leftImagecolor
        }
    }
    
    func updateView() {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: leftimageWidth * scrWidthRation, height: leftimageHeight * scrWidthRation))
        
            imageView.image = self.leftImage
            imageView.contentMode = .scaleAspectFit
        
            imageView.tintColor = leftImagecolor
            leftView = imageView
      
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftimageLeading * scrWidthRation
        return textRect
    }
    
    
    @IBInspectable open var isDropDown : Bool = false {
        didSet {
            addDropDownView()
        }
    }
    
    func addDropDownView() {
        if(isDropDown == true){
            self.rightViewMode = UITextFieldViewMode.always
            let rView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30 * scrWidthRation, height: self.frame.height))
            self.rightView = rView
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10 * scrWidthRation, height: 7 * scrWidthRation))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "dropDownArrow")
            self.rightView?.tintColor = textFieldInactiveColor
            rView.addSubview(imageView)
            imageView.center = CGPoint(x: (rView.frame.minX + imageView.frame.width / 2), y: rView.center.y)
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
    }
    
    @IBInspectable open var OuterPlaceholder : String = "" {
        didSet{
          //  self.addOutterPlaceHolder()
        }
    }
    
   
    
    override func becomeFirstResponder() -> Bool {
        self.activeTextFiled()
        super.becomeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        self.inActiveTextFiled()
        super.resignFirstResponder()
        return true
    }
    
    func inActiveTextFiled() {
        DispatchQueue.main.async { [unowned self] in
            self.borderColor = self.textFieldInactiveColor
            self.placeHolderLabel.textColor = self.textFieldInactiveColor
            self.leftView?.tintColor = self.textFieldInactiveColor
            self.rightView?.tintColor = self.textFieldInactiveColor
        }
    }
    
    func activeTextFiled() {
        DispatchQueue.main.async { [unowned self] in
            self.borderColor = self.textFieldActiveColor
            self.placeHolderLabel.textColor = self.textFieldActiveColor
            self.leftView?.tintColor = self.textFieldActiveColor
            self.rightView?.tintColor = self.textFieldActiveColor
        }
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: (leftimageLeading + leftimageTrailing + 15) * scrWidthRation, bottom: 0, right: 0)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: (leftimageLeading + leftimageTrailing + 15) * scrWidthRation, bottom: 0, right: 0)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: (leftimageLeading + leftimageTrailing + 15) * scrWidthRation, bottom: 0, right: 0)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
}
