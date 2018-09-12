//
//  Competition.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result


typealias Surveys = [Survey]

final class Survey: Model {
    // MARK: * Properties
    
    var _id: String?
    
    var __v: Int?

    var name: String?
    
    var questions: [Questions]?
    
    var title: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var sartDate: Date?

    var endDate: Date?
    
    var mediaUri: String?
    
    var byImageUri: String?

    var text: String?
    
    var byText: String?

    var description: String?


    /// The provider closure used by `moya` for default authorization headers used in requests against the api.
    
    static let providerClosure = { (target: Survey.API) -> Endpoint in
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
    
    static let stubbingBehavior = { (target: Survey.API) -> StubBehavior in
        return .never
    }
    
    /// The provider to use for middle ware of `moya`.
    
    static let provider = MoyaProvider<Survey.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
    

  }



