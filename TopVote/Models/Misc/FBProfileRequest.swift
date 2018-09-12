//
//  FBProfileRequest.swift
//  Topvote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import FacebookCore

struct FBProfileRequest: GraphRequestProtocol {
    typealias Response = GraphResponse
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, email, name, picture, location, age_range, gender"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = 2.7
}
