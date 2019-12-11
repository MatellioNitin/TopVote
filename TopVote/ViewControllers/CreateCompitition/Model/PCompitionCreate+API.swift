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
extension PCompitionCreate {
    enum API {
        case index(queryParams: [String: Any]?)
        case update(queryParams: [String: Any]?, competitionId: String)
        case updatePoll(queryParams: [String: Any]?, pollId: String)

        case userCompetitionCreate(queryParams: [String: Any]?)
        case userPollCreate(queryParams: [String: Any]?)

        case userCompetitionUpdate(queryParams: [String: Any]?, competitionId: String)
        case show(competitionId: String)
    }
}

// MARK: - Compeition / API / TargetType
extension PCompitionCreate.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case .index(_):
            return "/pvt-competitions"
        case let .update(_ , competitionId):
            return "/pvt-competitions/\(competitionId)"
        case let .updatePoll(_ , competitionId):
            return "/users-polls/\(competitionId)"
        case .userPollCreate(_):
            return "/users-polls"
        case .userCompetitionCreate(_):
            return "/users-competitions"
        case let .userCompetitionUpdate(_ , competitionId):
            return "/users-competitions/\(competitionId)"
            
        case let .show(competitionId):
            return "/accounts/\(competitionId)"
        }
    }

    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        case .index(_), .update(_,_), .updatePoll(_,_), .userCompetitionCreate(_), .userCompetitionUpdate(_,_), .userPollCreate(_ : _):
            return .post
        default:
            return .get
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any] {
        switch self {
        case let .index(queryParams):
            return queryParams!
            
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
        case let .index(params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        case let .userCompetitionCreate(params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        case let .userPollCreate(params):
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        case .show:
            return .requestPlain
        case let .update(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        case let .updatePoll(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
            
        case let .userCompetitionUpdate(params, _): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params!, encoding: JSONEncoding.default)
        }
    }
}

