//
//  Device.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/5/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

struct TVDevice: Model {
    // MARK: * Properties
    
    /// The document id.
    
    var _id: String?
    
    /// The document date of creation.
    
    var createdAt: Date?
    
    /// The document date of last update.
    
    var updatedAt: Date?
    
    var account: String?
    
    var providerId: String?
    
    var provider: Provider?
    
    var type: String?
    
    var model: String?
    
    var identifier: String?
    
    var adId: String?
    
    var version: String?
    
    var os: String?
    
    var language: String?
    
    var timezone: String?
    
    var tags: [String: String]?
    
    var subscribed: Bool?
    
    var location: Location?
}
