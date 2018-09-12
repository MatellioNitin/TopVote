//
//  Account+API.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit
import Moya

// MARK: - Account / API
extension Account {
    enum API {
        
        /// - Requires Following Parameters: `email`, `password`. Optional Parameters: `firstName`, `lastName`
        
        case create([String: Any])
        
        case index(queryParams: [String: Any]?)
        
        /// - Optional Parameters: `email`, `password`, `phoneNumber`, `firstName`, `lastName`
        
        case update(account: Account)
        
        /// - Requires Account Id.
        
        case show(accountId: String)
        
        /// - Requires Email Address & Password.
        
        case login([String: Any?])
        
        case entries(queryParams: [String: Any]?)
        
        case follow(accountId: String)
        
        case unfollow(accountId: String)
        
        case follows
        
        case me
        
        case activities
        
        case followingActivities
        
        case commentsIndex(entryId: String, queryParams: [String: Any]?)
        
        case commentsCreate(entryId: String, params: [String: Any])
        
        /// - Session Token Required.
        
        case logout()
//
//        case forgot(email: String)
//
//        case reset(password: String, code: String)
//
//        case verifyCode(accountId: String, code: String, params: [String: Any])
        
        case registerForNotifications(params: [String: Any])
        
        case subscribeForNotifications
        
        case unsubscribeForNotifications
        
        case categoryList

    }
}

// MARK: - Account / API / TargetType
extension Account.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case .create:
            return "/accounts"
        case .index(_):
            return "/accounts"
        case .update(_):
            return "/accounts/me"
        case let .show(accountId):
            return "/accounts/\(accountId)"
        case .login:
            return "/accounts/auth/login"
        case .entries:
            return "/entries"
        case let .follow(accountId):
            return "/accounts/me/follow/\(accountId)"
        case let .unfollow(accountId):
            return "/accounts/me/follow/\(accountId)"
        case .follows:
            return "/accounts/me/follows"
        case .me:
            return "/accounts/me"
        case .activities:
            return "/accounts/me/activities"
        case .followingActivities:
            return "/accounts/me/follows/activities"
            
        case let .commentsIndex(entryId, _):
            return "/accounts/me/entries/\(entryId)/comments"
            
        case let .commentsCreate(entryId, _):
            return "/accounts/me/entries/\(entryId)/comments"
            
        case .logout():
            return "/accounts/me/logout"
        
        case .registerForNotifications:
            return "/accounts/me/devices"
        case .subscribeForNotifications:
            let id = UIDevice.current.identifierForVendor?.uuidString ?? ""
            return "/accounts/me/devices/\(id)/subscribe"
        case .unsubscribeForNotifications:
            let id = UIDevice.current.identifierForVendor?.uuidString ?? ""
            return "/accounts/me/devices/\(id)/unsubscribe"
        case .categoryList:
          
            return "/accounts/me/devices/category"
//        case .forgot:
//            return ""
//        case .reset:
//            return ""
//        case let .verifyCode(accountId, code, _):
//            return "/accounts/\(accountId)/verifications/\(code)"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        case .create, .login, .logout, .follow(_), .commentsCreate(_), .registerForNotifications:
            return .post
        case .unfollow(_):
            return .delete
        case .update(_), .unsubscribeForNotifications:
            return .post
        default:
            return .get
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any] {
        switch self {
        case let .create(params):
            return params
        case let .index(queryParams), let .commentsIndex(_, queryParams), let .entries(queryParams):
            return queryParams ?? [String: Any]()
        case let .update(account):
            let params = account.dictionary
            return params
        case let .login(params):
            return params
        case let .registerForNotifications(params):
            return params
//        case let .forgot(email):
//            return ["email": email]
//        case let .reset(password, code):
//            return ["password": password, "code": code]
//        case let .verifyCode(_, _, params):
//            return params
        default:
            return [String: Any]()
        }
    }
//    public var parameters: [String: Any]? {
//        switch self {
//        case let .create(params):
//            return params
//        case let .index(queryParams):
//            return queryParams
//        case let .update(account):
//            let params = Account.dictionary(model: account)
//            return params
//        case let .login(params):
//            return params
//        case let .forgot(email):
//            return ["email": email]
//        case let .reset(password, code):
//            return ["password": password, "code": code]
//        case let .verifyCode(_, _, params):
//            return params
//        default:
//            return nil
//        }
//    }
    
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
        case let .index(queryParams), let .commentsIndex(_, queryParams), let .entries(queryParams):
            if let queryParams = queryParams {
                return .requestParameters(parameters: queryParams, encoding: URLEncoding.queryString)
            }
            return .requestPlain
        case .logout, .show, .unfollow, .follow, .follows, .me, .activities, .followingActivities:
            return .requestPlain
        case let .update(account):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: Account.dictionary(model: account), encoding: JSONEncoding.default)
        case let .create(params), let .commentsCreate(_, params): // Always send parameters as JSON in request body
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .login(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .registerForNotifications(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .subscribeForNotifications:
            return .requestPlain
        case .unsubscribeForNotifications:
            return .requestPlain
        case .categoryList:
            return .requestPlain
        }
    }
    
//    public var parameterEncoding: ParameterEncoding {
//        switch self {
//        case let .index(queryParams):
//            if queryParams != nil {
//                return URLEncoding.default
//            } else {
//                return JSONEncoding.default
//            }
//        default:
//            return JSONEncoding.default
//        }
//    }
}
