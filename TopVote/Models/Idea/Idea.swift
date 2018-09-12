//
//  Idea.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/29/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result

typealias Ideas = [Idea]

final class Idea: Model, Hashable {
    
    var hashValue: Int {
        return _id?.hashValue ?? 0
    }
    
    // MARK: * Properties
    
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var account: Account?
    
    var text: String?
    
    var numberOfVotes: Int?
    
    var valueVotes: Int?
    
    var hasVoted: Bool?
    
    func isAuthor() -> Bool {
        return account?._id == AccountManager.session?.account?._id
    }
    
    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let providerClosure = { (target: Idea.API) -> Endpoint in
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
    
    static let stubbingBehavior = { (target: Idea.API) -> StubBehavior in
        return .never
    }
    
    /// The provider to use for middle ware of `moya`.
    
    static let provider = MoyaProvider<Idea.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
    
    // MARK: * Instant methods
}
