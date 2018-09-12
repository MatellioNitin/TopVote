//
//  ModelLocation.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/7/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

struct AddressLocation: ModelGenerator {
    // MARK: * Properties
    
    /// The city the retainer resides in.
    
    var city: String?
    
    /// The state the retainer resides in.
    
    var state: String?

    /// The country the retainer resides in.
    
    var country: String?

    /// The county the retainer resides in.
    
    var county: String?
    
    /// The street the retainer resides in.
    
    var street: String?
    
    /// the postal, zip code.
    
    var postalCode: String?

    // MARK: * Instant methods
    
    /// Initializer for model of dictionary type. [String: Any]
    ///
    /// - Parameter dictionary: the dictionary to convert to Model Type.
    
    init(dictionary: [String: Any]) {
        city = dictionary["city"] as? String
        state = dictionary["state"] as? String
        country = dictionary["country"] as? String
        county = dictionary["county"] as? String
        street = dictionary["street"] as? String
        postalCode = dictionary["postalCode"] as? String
    }
    
    /// Converts a Model to Dictionary type. [String: Any]
    ///
    /// - Parameter model: the model to convert.
    /// - Returns: dictionary [String: Any].
    
    static func dictionary<T: ModelGenerator>(model: T) -> [String: Any] {
        var aDictionary = [String: Any]()
        
        let location = model as! AddressLocation
       
        if let value = location.city {
            aDictionary["city"] = value
        }
        
        if let value = location.state {
            aDictionary["state"] = value
        }
        
        if let value = location.country {
            aDictionary["country"] = value
        }
        
        if let value = location.county {
            aDictionary["county"] = value
        }
        
        if let value = location.street {
            aDictionary["street"] = value
        }
        
        if let value = location.postalCode {
            aDictionary["postalCode"] = value
        }
        
        return aDictionary
    }
}
