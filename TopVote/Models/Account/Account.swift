//
//  Account.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import Moya
import Result

/// Array of Accounts. typealias of [Account]
typealias Accounts = [Account]

final class Account: Model {
    // MARK: * Properties
    
    /// The document id.
    
    var _id: String?

    /// The document creation date in utc.
    
    var createdAt: Date?
    
    /// The document last updated date in utc.
    
    var updatedAt: Date?
    
    /// The email address of the account.
    
    var email: String?
    
    var username: String?
    
    var verified: Verified?
    
    var profileImageUri: String?
    
    var name: String?
    
    var bio: String?
    
    var locationName: String?
    
    //  TODO: This is not scalable...
    
    var followers: Int?
    
    var following: Int?
    
    var followingAccount: Bool?

    var competitionsWon: Int?
    
    var competitionsEntered: Int?
    
    var votesReceived: Int?
    
    var votesGiven: Int?
    
    var sharesReceived: Int?
    
    var sharesGiven: Int?
    
    var profileViews: Int?
    
    var categories: [String]?

    var excluded: [String] {
        return [
            "excluded",
            "createdAt",
            "updatedAt",
            "verified",
            "followers",
            "following",
            "followingAccount",
            "competitionsWon",
            "competitionsEntered",
            "votesReceived",
            "votesGiven",
            "sharesReceived",
            "sharesGiven",
            "profileViews"
        ]
    }
    
    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let providerClosure = { (target: Account.API) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        var absolutePath = try! defaultEndpoint.urlRequest().url?.path ?? ""
        if let query = try! defaultEndpoint.urlRequest().url?.query {
            absolutePath = absolutePath + "?" + query
        }
        let headerFields = URLRequest.authHeaders(httpMethod: defaultEndpoint.method.rawValue, urlPath: absolutePath, version: target.version)
        let endpointWithHeaders = defaultEndpoint.adding(newHTTPHeaderFields: headerFields)
        return endpointWithHeaders
    }
    
    /// the stubbing behavior moya should use for this document. will stub fake data for accounts if set to enum value of .immediate.
    
    static let stubbingBehavior = { (target: Account.API) -> StubBehavior in
        return .never
    }
    
    /// The provider to use for middle ware of `moya`.
    
    static let provider = MoyaProvider<Account.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
}
