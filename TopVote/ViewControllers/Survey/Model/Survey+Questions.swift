//
//  Account+Verified.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/8/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

extension Survey {
    struct Questions: ModelGenerator {
        // MARK: * Properties
                
        var _id: String?
        
        var __v: Int?
        
        var questionOptions: [QuestionOptions]
        
        var createdAt: Date?
        
        var updatedAt: Date?
        
        var question: String?
        
        var description: String?

        var surveyId: String?
        
        var selected: String?

        
    }
}
