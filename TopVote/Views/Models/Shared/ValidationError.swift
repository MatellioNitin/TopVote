//
//  ValidationError.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/9/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

// example of what Mongoose Validation Error returns.
/*
{
    "message" : "Validation failed",
    "error" : {
        "username" : {
            "path" : "username",
            "message" : "Validator failed for path `username` with value `lukers`",
            "properties" : {
                "type" : "Duplicate value",
                "path" : "username",
                "value" : "lukers"
            },
            "kind" : "Duplicate value",
            "name" : "ValidatorError",
            "value" : "lukers"
        }
    }
}
*/

import Foundation

struct ValidationError: ModelGenerator {
    
    static let validationMessage = "Validation failed"
    
    var key: String?
    
    var path: String?
    
    var message: String?
    
    var properties: ValidationErrorProperties?
    
    var kind: String?
    
    var name: String?
    
    var value: String?
    
    var errorMessage: String?
    
    // MARK: * Instant methods
    
    /// Initializer for model of dictionary type. [String: Any]
    ///
    /// - Parameter dictionary: the dictionary to convert to Model Type.
    
    init(dictionary: [String: Any]) {
        for (key, val) in dictionary {
            self.key = key
            
            if let info = val as? [String: Any] {
                path = info["path"] as? String
                
                message = info["message"] as? String
                
                if let value = info["properties"] as? [String: Any] {
                    properties = ValidationErrorProperties(dictionary: value)
                }
                
                kind = info["kind"] as? String
                
                name = info["name"] as? String

                value = info["value"] as? String
            }
            
            break
        }
        
        errorMessage = formatErrorMessage()
    }
    
    /// Converts a Model to Dictionary type. [String: Any]
    ///
    /// - Parameter model: the model to convert.
    /// - Returns: dictionary [String: Any].
    
    static func dictionary<T: ModelGenerator>(model: T) -> [String: Any] {
        var aDictionary = [String: Any]()
        
        let validationError = model as! ValidationError
        
        if let val = validationError.key {
            var dictionary = [String: Any]()

            if let path = validationError.path {
                dictionary["path"] = path
            }
           
            if let path = validationError.path {
                dictionary["path"] = path
            }
            
            if let message = validationError.message {
                dictionary["message"] = message
            }
            
            if let value = validationError.properties {
                dictionary["properties"] = ValidationErrorProperties.dictionary(model: value)
            }
            
            if let kind = validationError.kind {
                dictionary["kind"] = kind
            }
            
            if let name = validationError.name {
                dictionary["name"] = name
            }
            if let value = validationError.value {
                dictionary["value"] = value
            }
            
            aDictionary[val] = dictionary
        }
        
        return aDictionary
    }
    
    // MARK: * Format Error
    func formatErrorMessage() -> String? {
        if let kind = kind, let path = path, let value = value {
            if kind.contains("Duplicate") {
                if path.contains("username") {
                    return "Username with \"\(value)\" already exists. Please choose another Username."
                } else if path.contains("email") {
                    return "Account with \"\(value)\" already exists. Please sign in or choose a different email address"
                }
            }
        }
        
        return nil
    }
}

struct ValidationErrorProperties: ModelGenerator {
    // MARK: * Properties
    var type: String?
    
    var path: String?
    
    var value: String?
    
    // MARK: * Instant methods
    
    /// Initializer for model of dictionary type. [String: Any]
    ///
    /// - Parameter dictionary: the dictionary to convert to Model Type.
    
    init(dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        
        path = dictionary["path"] as? String
        
        value = dictionary["value"] as? String
    }
    
    /// Converts a Model to Dictionary type. [String: Any]
    ///
    /// - Parameter model: the model to convert.
    /// - Returns: dictionary [String: Any].
    
    static func dictionary<T: ModelGenerator>(model: T) -> [String: Any] {
        var aDictionary = [String: Any]()
        
        let properties = model as! ValidationErrorProperties
        
        if let val = properties.type {
            aDictionary["type"] = val
        }
        
        if let val = properties.path {
            aDictionary["path"] = val
        }
        
        if let val = properties.value {
            aDictionary["value"] = val
        }
        
        return aDictionary
    }

}
