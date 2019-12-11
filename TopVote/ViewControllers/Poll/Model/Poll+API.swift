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
extension Poll {
    enum API {
        case getPollDeepLink(getPollId: String)
        case getPoll(getPollId: String)
        case getUsersPoll(getPollId: String)

        case getPollleaderboardDetail(getPollId: String)
        case setPoll(queryParams: [String: Any]?)

    }
}

// MARK: - Compeition / API / TargetType
extension Poll.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case let .getPollDeepLink(getPollId):
            return "/polls/\(getPollId)/deeplink"
        case let .getPoll(getPollId):
            return "/polls/\(getPollId)"
        case let .getUsersPoll(getPollId):
            return "/users-polls/\(getPollId)"
            
        case let .getPollleaderboardDetail(getPollId):
            return "/polls/\(getPollId)/result"
        case .setPoll(_):
            return "/polls/vote"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        case .setPoll(_):
            return .post
        default:
            return .get
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any] {
        switch self {
        case let .setPoll(queryParams):
            return queryParams!
        default:
            return [String: Any]()
        }
    }
    
    /// The method used for parameter encoding.
    
    func encodingType() -> ParameterEncoding {
        switch self {
        case let .setPoll(queryParams):
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
        case let .setPoll(queryParams):
            return .requestParameters(parameters: queryParams!, encoding: JSONEncoding.default)

        case .getPoll, .getUsersPoll, .getPollDeepLink, .getPollleaderboardDetail:
            return .requestPlain
      
        }
    }
}

