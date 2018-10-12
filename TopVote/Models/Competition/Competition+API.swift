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
extension Competition {
    enum API {
        case indexHall(queryParams: [String: Any]?)
        case index(queryParams: [String: Any]?)
        case privateCompetition(queryParams: [String: Any]?)
        case show(competitionId: String)
    }
}

// MARK: - Compeition / API / TargetType
extension Competition.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
            
      //  case .indexHall(_):
          //  return "/competitions"
        case .indexHall(_):
                return "/competitions/completed"
        case .index(_):
            return "/competitions/all"
        case .privateCompetition(_):
            return "/pvt-competitions/my-competitions"
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
        case let .indexHall(queryParams):
            return queryParams ?? [String: Any]()
        case let .index(queryParams):
            return queryParams ?? [String: Any]()
        case let .privateCompetition(queryParams):
            return queryParams ?? [String: Any]()
        default:
            return [String: Any]()
        }
    }
    
    /// The method used for parameter encoding.
    
    func encodingType() -> ParameterEncoding {
        switch self {
        case let .indexHall(queryParams):
            if queryParams != nil {
                return URLEncoding.default
            } else {
                return JSONEncoding.default
            }
        case let .index(queryParams):
            if queryParams != nil {
                return URLEncoding.default
            } else {
                return JSONEncoding.default
            }
        case let .privateCompetition(queryParams):
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
        case let .indexHall(queryParams):
            if let queryParams = queryParams {
                return .requestParameters(parameters: queryParams, encoding: URLEncoding.default)
            }
            return .requestPlain
        case let .index(queryParams):
            if let queryParams = queryParams {
                return .requestParameters(parameters: queryParams, encoding: URLEncoding.default)
            }
            return .requestPlain
        case let .privateCompetition(queryParams):
            if let queryParams = queryParams {
                return .requestParameters(parameters: queryParams, encoding: URLEncoding.default)
            }
            return .requestPlain
            
//        case  .privateCompetition:
//            return .requestPlain
        case .show:
            return .requestPlain
        }
    }
}

