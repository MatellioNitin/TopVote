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
    
    func snapshotRows(at indexPaths: Set<IndexPath>) -> UIImage?
    {
        guard !indexPaths.isEmpty else { return nil }
        
        var rect = self.rectForRow(at: indexPaths.first!)
        for indexPath in indexPaths
        {
            let cellRect = self.rectForRow(at: indexPath)
            rect = rect.union(cellRect)
        }
        
        rect.size.height  =  rect.size.height - 50
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for indexPath in indexPaths
        {
            let cell = self.cellForRow(at: indexPath)
            cell?.layer.bounds.origin.y = self.rectForRow(at: indexPath).origin.y - rect.minY
            cell?.layer.render(in: context)
            cell?.layer.bounds.origin.y = 0
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

