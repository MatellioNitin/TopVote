//
//  Entry+API.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import UIKit
import Moya

// MARK: - Entry / API
extension Entry {
    enum API {
        case create([String: Any])
        
        case index(queryParams: [String: Any]?)
        
        case update(entry: Entry)
        
        case show(entryId: String)
        
        case destroy(entryId: String)
        
        case getEntry(entryId: String)
        
        case getCompStatus(compId: String)

        case vote(params: [String: Any], entryId: String)
        
        case flag(params: [String: Any], entryId: String)
        
        case updateEntry(params: [String: Any], entryId: String)

    }
}

// MARK: - Entry / API / TargetType
extension Entry.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case .create:
            return "/entries"
        case .index(_):
            return "/entries"
        case let .getCompStatus(compId):
            return "/entries/participated/\(compId)"
        case .update(_):
            return "/entries"
        case let .getEntry(entryId):
            return "/entries/\(entryId)"
        case let .destroy(entryId):
            return "/entries/\(entryId)"
        case let .show(entryId):
            return "/entries/\(entryId)"
        case let .vote(_, entryId):
            return "/entries/\(entryId)/vote"
        case let .flag(_, entryId):
            return "/entries/\(entryId)/flag"
            
        case let .updateEntry(_, entryId):
            return "/entries/\(entryId)"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .update(_), .vote(_, _), .flag(_, _), .updateEntry(_, _):
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
            let params = entry.dictionary
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
        case .show, .destroy, .getCompStatus, .getEntry:
            return .requestPlain
        case let .update(entry):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: Entry.dictionary(model: entry), encoding: JSONEncoding.default)
        case let .create(params): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .vote(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .flag(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .updateEntry(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}

