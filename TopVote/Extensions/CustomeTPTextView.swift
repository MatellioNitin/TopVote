//
//  UITextView+Placeholder.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

class CustomeTPTextView: UITextView {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool{
                if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                    return false
                }
                return super.canPerformAction(action, withSender: sender)
            }
}
