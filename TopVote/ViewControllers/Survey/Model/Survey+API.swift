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
extension Survey {
    enum API {
        
        case getSurveyDeeplink(getSurveyId: String)

        case getSurvey(getSurveyId: String)
        
        case setSurvey(queryParams: [String: Any]?)

    }
}

// MARK: - Compeition / API / TargetType
extension Survey.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case let .getSurveyDeeplink(surveyId):
            return "/surveys/\(surveyId)/deeplink"
        case let .getSurvey(surveyId):
            return "/surveys/sqo/\(surveyId)"
        case .setSurvey(_):
            return "/surveys/submissions/submit"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
            case .setSurvey(_):
            return .post
        default:
            return .get
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any] {
        switch self {
        case let .setSurvey(queryParams):
            return queryParams!
        default:
            return [String: Any]()
        }
    }
    
    /// The method used for parameter encoding.
    
    func encodingType() -> ParameterEncoding {
        switch self {
        case .setSurvey(_):
                return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case let .setSurvey(queryParams):
            return .requestParameters(parameters: queryParams!, encoding: JSONEncoding.default)
        case .getSurvey, .getSurveyDeeplink:
            return .requestPlain
        }
    }
}

