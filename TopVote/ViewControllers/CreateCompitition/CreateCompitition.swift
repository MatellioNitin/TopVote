//
//  Competition.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation


typealias CreateCompititions = [CreateCompitition]
typealias CreatePollOptions = [CreatePollOption]

 class CreateCompitition: NSObject {
    
    // MARK: * Properties
    var _id: String?
    
    var inputType: Int? // 1 = textBox,  2 = Picker, 3 = datepicker
    var placeHolder: String?
    var title: String?
    var value: String?
    var selectType: String?
    var optionImage: String?
    var descriptionPoll: String?

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
    func setPollData(type:String, imageOption:String, description:String) {

        selectType = type
        optionImage = imageOption
        descriptionPoll = description
    }
    
  }


class CreatePollOption: NSObject {
    
    // MARK: * Properties
    var _id: String? = ""
    var type: String? = ""
    var title: String? = ""
    var optionText: String? = ""
    
    override init() {
        super.init()
    }

    func setPollData(id:String, type1:String, title1:String, optionText1:String) {
        _id = id
        type = type1
        title = title1
        optionText = optionText1
    }
    
}
