//
//  AppConfig.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import Result
import Moya

/// AppConfig Model associated with platform in the system.

struct AppConfig: Model {
    // MARK: - Properties
    
    /// The document id.
    
    var _id: String?
    
    /// the name of the app.
    
    var name: String?
    
    /// the platform is in maintenance, disable any action till maintenance is complete.
    
    var maintenance: Bool = false
    
    /// the maintenance message to display when the app is in maintenance.
    
    var maintenanceMessage: String?
    
    /// the url for the app.
    
    var apiUrl: String?
    
    /// the apps required minimum version.
    
    var minimumVersion: String?
    
    /// the current version of the app.
    
    var currentVersion: String?
    
    /// the update url for itunes connect.
    
    var updateUrl: String?
    
    /// the id that is ios specific.
    
    var iOSAppId: String?
    
    /// the url api.
    
    var clientURL: String?
    
    /// the amount of time inbetween pulls for updated app config.
    
    var pollingRefreshSeconds: TimeInterval?
    
    /// a url path used for gorgot password navigation.
    
    var forgotPasswordPath: String?
    
    /// a url for verifying account navigation.
    
    var verifyPath: String?
    
    /// a url for activating account navigation.
    
    var activatePath: String?
    
    /// the current enviroment the app is using.
    
    var environment: String?
    
    /// the document creation date in utc.
    
    var createdAt: Date?
    
    /// the document updated date in utc.
    
    var updatedAt: Date?
    
    /// a regex for password validation.
    
    var authRegEx: String?
    
    /// the support email for the app.
    
    var supportEmail: String = ""
    
    /// the support phone number for the app.

    var supportNumber: String?
    
    /// the support message to display for the app.

    var supportMessage: String?
    
    /// the activity list tied to this document.
    
    static let providerClosure = { (target: AppConfig.API) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        let headerFields = URLRequest.authHeaders(httpMethod: defaultEndpoint.method.rawValue, urlPath: target.path, version: target.version)
        let endpointWithHeaders = defaultEndpoint.adding(newHTTPHeaderFields: headerFields)
        return endpointWithHeaders
    }
    
    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let stubbingBehavior = { (target: AppConfig.API) -> StubBehavior in
        return .never
    }
    
    /// the stubbing behavior moya should use for this document. will stub fake data for accounts if set to enum value of .immediate.
    
    static let provider = MoyaProvider<AppConfig.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior,    plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
}
