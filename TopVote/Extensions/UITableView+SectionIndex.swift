//
//  UITableView+SectionIndex.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// UITableView Extension.
extension UITableView {
    
    /// A convenience function for style section index of UITableView
    ///
    /// - Parameter font: the font of the section index.
    
    func changeSectionIndexFont(font: UIFont = UIFont.systemFont(ofSize: 18.0)) {        
        let tableSubViews = self.subviews

        for subview in tableSubViews where type(of: subview).className == "UITableViewIndex" {
            subview.setValue(font, forKey: "font")
        }
    }
}
