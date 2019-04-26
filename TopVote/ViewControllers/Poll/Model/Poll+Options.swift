//
//  Account+Verified.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/8/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

extension Poll {
    struct Options: ModelGenerator {
        // MARK: * Properties
        
        /// Account Email Address has been verified or not.
        
        var _id: String?
        
        var title: String?
        
        var optionText: String?

        var type: Int?



    }
}
