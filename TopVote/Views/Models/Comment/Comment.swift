//
//  Comment.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 10/24/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result

typealias Comments = [Comment]

final class Comment: Model {
    // MARK: * Properties
    
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var account: Account?
    
    var entry: Entry?
    
    var text: String?
}
