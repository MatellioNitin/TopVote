//
//  Idea+API.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/29/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
//import UIKit
import Moya

// MARK: - Idea / API
extension Idea {
    enum API {
        case create([String: Any])
        
        case index(queryParams: [String: Any]?)
        
        case update(idea: Idea)
        
        case show(ideaId: String)
        
        case destroy(ideaId: String)
        
        case vote(params: [String: Any], ideaId: String)
    }
}

// MARK: - Idea / API / TargetType
extension Idea.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case .create:
            return "/ideas"
        case .index(_):
            return "/ideas"
        case .update(_):
            return "/ideas"
        case let .destroy(ideaId):
            return "/ideas/\(ideaId)"
        case let .show(ideaId):
            return "/ideas/\(ideaId)"
        case let .vote(_, ideaId):
            return "/ideas/\(ideaId)/vote"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .update(_), .vote(_, _):
            return .post
        case .destroy(_):
            return .delete
        default:
            return .get
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any] {
        switch self {
        case let .create(params):
            return params
        case let .index(queryParams):
            return queryParams ?? [String: Any]()
        case let .update(entry):
            let params = Entry.dictionary(model: entry)
            return params
        default:
            return [String: Any]()
        }
    }
    
    func encodingType() -> ParameterEncoding {
        switch self {
        case let .index(queryParams):
            if queryParams != nil {
                return URLEncoding.default
            } else {
                return JSONEncoding.default
            }
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case let .index(queryParams):
            if let queryParams = queryParams {
                return .requestParameters(parameters: queryParams, encoding: URLEncoding.queryString)
            }
            return .requestPlain
        case .show, .destroy:
            return .requestPlain
        case let .update(entry):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: Entry.dictionary(model: entry), encoding: JSONEncoding.default)
        case let .create(params): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .vote(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
