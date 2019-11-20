//
//  AppConfig+Requests.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

// MARK: - AppConfig / Request
extension AppConfig {
    
    // MARK: * Static methods
    
    /// Fetches App Config.
    ///
    /// - Parameters:
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on app config.
    
    static func config(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ appConfig: AppConfig) -> Void) {
        AppConfig.provider.request(AppConfig.API.config) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let appConfig: AppConfig = AppConfig.create(data: value) {
                    completion(appConfig)
                } else {
                    error(errorMessage!)
                }
            })
        }
    }
    
    /// Show App Details
    ///
    /// - Parameters:
    ///   - appId: the app document id.
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on app show.
    
    static func findOne(appId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ app: AppConfig) -> Void) {
//        AppConfig.provider.request(AppConfig.API.show(appId: appId)) { result in
//            result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let value = object as? [String: Any] {
//                    let app = AppConfig(dictionary: value)
//                    completion(app)
//                } else {
//                    error(errorMessage!)
//                }
//            })
//        }
    }
}
