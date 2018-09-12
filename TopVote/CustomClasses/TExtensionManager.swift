//
//  TExtensionManager.swift
//  Softaps
//
//  Created by Anuj on 20/07/18.
//  Copyright © 2018 CGT. All rights reserved.
//

import UIKit


// AppDelegate()
let imagePickerManager:TImagePickerManager = TImagePickerManager()

// screen dimention
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
let scrHeightRation = screenHeight / 667.00
let scrWidthRation = screenWidth / 375.00

class TExtensionManager: NSObject {
    
}

// ColorCodes
struct kColor {
    static let textFieldInActive = UIColor(hexString: "A9A9A9")
    static let textFieldActive =  UIColor(hexString: "0000000")
    static let pinkColor =  UIColor(hexString: "C8254C")
    
}



func showActionSheet(title:String?, withMessage:String) -> Void
{
    let alert = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let act = UIAlertAction.init(title: "OK", style: .default) { (alert) in
        
    }
    if(title != nil){
        alert.addAction(act)
    }

    if(title == nil){
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIColor{
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UITextField {
    var isEmpty : Bool {
        set {
            self.isEmpty = newValue
        }
        get {
            if(self.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                return true
            } else{
                return false
            }
        }
        
    }
}

