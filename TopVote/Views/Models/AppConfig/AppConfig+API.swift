//
//  AppConfig+API.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit
import Moya

// MARK: - AppConfig / API
extension AppConfig {
    
    /// AppConfig.API used for end points associated app configuration.
    ///
    /// - config: Fetches Application Configuration, Method: `GET`, EndPoint: `/config`
    /// - show: Fetches App, Method: `GET`, EndPoint: `/apps/:id`
    
    enum API {
        
        /// - Fetches Application Configuration.
        
        case config
        
        /// - Fetches App.
        
        //case show(appId: String)
    }
}

// MARK: - AppConfig / API / TargetType
extension AppConfig.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    var task: Task {
        switch self {
        case .config: // Send no parameters
            return .requestPlain
        }
    }
    
    public var path: String {
        switch self {
        case .config:
            return "/config"
//        case let .show(appId):
//            return "/apps/\(appId)"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    
    public var parameters: [String: Any]? {
        return nil
    }
}
