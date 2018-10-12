//
//  Competition.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result


typealias Categorys = [Category]

final class Category: Model {
    // MARK: * Properties
    
    var _id: String?

    var name: String?
    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let providerClosure = { (target: Category.API) -> Endpoint in
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
    
    static let stubbingBehavior = { (target: Category.API) -> StubBehavior in
        return .never
    }
    
    /// The provider to use for middle ware of `moya`.
    
    static let provider = MoyaProvider<Category.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
    

    
  }



