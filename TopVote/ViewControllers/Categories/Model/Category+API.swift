//
//  Compeition+API.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import UIKit
import Moya

// MARK: - Compeition / API
extension Category {
    enum API {
        
        
        case deepLink(deepLinkId: String)

        case index(queryParams: [String: Any]?)
        
        case p2pCheck()

        case show(competitionId: String)
    }
}

// MARK: - Compeition / API / TargetType
extension Category.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case let .deepLink(deepLinkIds):
            return "/pvt-competitions/add-user/\(deepLinkIds)"
        case .index(_):
            return "/categories"
        case .p2pCheck:
            return "/apps/settings"

        case let .show(competitionId):
            return "/accounts/\(competitionId)"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any] {
        switch self {
        case let .index(queryParams):
            return queryParams ?? [String: Any]()
        default:
            return [String: Any]()
        }
    }
    
    /// The method used for parameter encoding.
    
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
                return .requestParameters(parameters: queryParams, encoding: URLEncoding.default)
            }
            return .requestPlain
        case .deepLink, .p2pCheck:
            return .requestPlain
        case .show:
            return .requestPlain
        }
    }
}

