//
//  Competition.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation


typealias CreateCompititions = [CreateCompitition]

 class CreateCompitition: NSObject {
    
    // MARK: * Properties
    var _id: String?

    
    var inputType: Int? // 1 = textBox,  2 = Picker, 3 = datepicker
    
    var placeHolder: String?
    var title: String?
    var value: String?

    var arrayList: [String] = []

    override init() {
        super.init()
    }
    func setData(type:Int, titleStr:String, placeHolderStr:String, valueStr:String, pickerArrayList:[String]) {
        
        inputType = type
        title = titleStr
        value = valueStr
        placeHolder = placeHolderStr
        arrayList = pickerArrayList

    }
    
  }



