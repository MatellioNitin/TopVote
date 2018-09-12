//
//  UtilityManager.swift
//  Softaps
//
//  Created by Anuj on 20/07/18.
//  Copyright © 2018 CGT. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD

class UtilityManager: NSObject {

    class func normalPicker() -> UIPickerView
    {
        var picker: UIPickerView!
        picker = UIPickerView(frame:CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:216))
        picker.backgroundColor = UIColor.white
        return picker
    }
    
    class func picker_Date_Create() -> UIDatePicker
    {
        var pickerDateTime: UIDatePicker!
        pickerDateTime = UIDatePicker(frame:CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:216))
        
        pickerDateTime.backgroundColor = UIColor.white
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm a"
        
        if let date = dateFormatter.date(from:"12:00 AM") {
            pickerDateTime.date = date
        }
        
        return pickerDateTime
        
    }
    class func RemoveHUD()
    {
        SVProgressHUD.dismiss()
    }
    class func ShowHUD(text:String, bgType:SVProgressHUDMaskType = .black, styleType:SVProgressHUDStyle = .light, view:UIView = ((UIApplication.shared.delegate?.window)!)!)
    {
        _ = UIApplication.shared.delegate as! AppDelegate
        
        SVProgressHUD.setDefaultMaskType(bgType)
        SVProgressHUD.setDefaultStyle(styleType)
        SVProgressHUD.setForegroundColor(UIColor.black)
        
        SVProgressHUD.setContainerView(view)
        SVProgressHUD.setStatus(text)
        SVProgressHUD.show(withStatus: text)
    }
}
