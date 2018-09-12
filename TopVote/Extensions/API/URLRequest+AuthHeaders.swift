//
//  URLRequest+AuthHeaders.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import Moya

/// Extend URLRequest for helper functions used in all models of the application utilizing Moya.

extension URLRequest {
    
    /// A convenience that wraps our auth headers for API.
    /// Handles Hash/HmacSha256 our key and secret
    ///
    /// - Parameters:
    ///   - httpMethod: The crud method to implement on api.
    ///   - urlPath: the url path for end point.
    ///   - version: the version the api should be executing for request.
    /// - Returns: auth header dictionary, returns `Date`, `Authorization`, `Content-Type`, & `Accepted-Version`
    
    static func authHeaders(httpMethod: String, urlPath: String, version: String) -> [String: String] {
        var authParam = ""
        let timeStamp = NSDate().timeIntervalSince1970
        let timeStampString = String(format: "%.21f", timeStamp)

        var signature = String(format: "%@\n", httpMethod)
        signature.append("\n")
        signature.append("\n")
        signature = signature.appendingFormat("%@\n", timeStampString)
        signature = signature.appendingFormat("%@", urlPath)
        
        let sigDigest = (signature as String).stringDigestUsingHmacSha256WithKey(key: Config.apiSecret)
        let sigData = sigDigest.data(using: .utf8, allowLossyConversion: false)
        if let sigDataEncoded = sigData?.base64EncodedString() {
            authParam = String(format: "SID %@:%@", Config.apiKey, sigDataEncoded)
        }
                
        var headers = [
            "Date": timeStampString,
            "Authorization": authParam,
            "Content-Type": "application/json",
            "Accept-Version": "<="+version
        ]
        
        if let token = AccountManager.sessionToken {
            headers["api-session-token"] = token
        }
        
        return headers
    }
}
