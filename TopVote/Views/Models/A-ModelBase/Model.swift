//
//  Model.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/5/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

/// Model Protocol from which all models within application conform to.
protocol Model: ModelGenerator {
    
    /// The document id.
    
    var _id: String? { get }
    
    /// The document date of creation.
    
    var createdAt: Date? { get }
    
    /// The document date of last update.
    var updatedAt: Date? { get }
}

extension Model {
    var createdAt: Date? {
        return nil
    }
    
    var updatedAt: Date? {
        return nil
    }
    
    var excluded: [String] {
        return ["excluded", "createdAt", "updatedAt"]
    }
}
