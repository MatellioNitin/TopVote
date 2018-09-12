//
//  Moya+Response.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import Moya

/// Extend Moya Response for helper functions used in Moya Respobnse.

extension Moya.Response {
    
    /// Maps JSON as [Any] array if possible.
    ///
    /// - Returns: array of [Any]
    /// - Throws: error if it cannot map JSON as swift array type.
    
    func mapArray() throws -> [Any] {
        let any = try self.mapJSON()
        guard let array = any as? [Any] else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
    
    /// Maps JSON as [String: Any] dictionary if possible.
    ///
    /// - Returns: dictionary of [String: Any]
    /// - Throws: error if it cannot map JSON as swift dictionary type.
    
    func mapDictionary() throws -> [String: Any] {
        let any = try self.mapJSON()
        guard let dictionary = any as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        return dictionary
    }
    
    /// A convenience function for serializing data into readable JSON.
    ///
    /// - Parameter data: the data to serialize
    /// - Returns: data serilized for JSON interpretation.
    
    static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
}
