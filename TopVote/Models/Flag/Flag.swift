//
//  Flag.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/25/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result

typealias Flags = [Flag]

final class Flag: Model {
    // MARK: * Properties
    
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var account: Account?
    
    var entry: Entry?
    
    var status: Int?
    
    var privateCompetition: Int?

    var participated: Bool?

    var value: Int?

    
}
