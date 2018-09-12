//
//  API+Target.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import Moya

/// Extend Moya TargetType for base functions used in all models of the application.

extension TargetType {
    
    var headers: [String : String]? {
        return URLRequest.authHeaders(httpMethod: self.method.rawValue, urlPath: self.path, version: self.version)
    }
    
    /// The target's base `URL`.

    public var baseURL: URL {
        return URL(string: Config.host)!
    }

    /// Provides targets `version` for api requests.

    public var version: String {
        return Config.version
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    
    public var validate: Bool {
        return false
    }
    
    /// The type of HTTP task to be performed.

//    public var task: Task {
////        return .requestPlain
//        return .requestParameters(parameters: self.params(), encoding: self.encodingType())
//    }
    
    /// The method used for parameter encoding.

    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    /// Provides stub data for use in testing.

    public var sampleData: Data {
        switch self {
        default:
            return "Test Test".data(using: String.Encoding.utf8)!
        }
    }
}
