//
//  ModelGenerator+JSON.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/5/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

// MARK: - ModelJSONGenerator
protocol ModelJSONGenerator: ModelGenerator {
    /// Initializer for model of dictionary type. [String: Any]
    ///
    /// - Parameter dictionary: the dictionary to convert to Model Type.
    
    init(dictionary: [String: Any])
    
    /// Initializer for generic array of Models.
    ///
    /// - Parameter array: a array of [[String: Any]] type.
    /// - Returns: Generic Array of Models [<T: Model>]
    
    static func models<T: ModelJSONGenerator>(array: [[String: Any]]) -> [T]
}

extension ModelJSONGenerator {
    /// Initializer for generic array of Models.
    ///
    /// - Parameter array: a array of [[String: Any]] type.
    /// - Returns: Generic Array of Models [<T: Model>]
    
    static func models<T: ModelJSONGenerator>(array: [[String: Any]]) -> [T] {
        return array.map{T.init(dictionary: $0)}
    }
}
