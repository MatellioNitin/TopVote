//
//  Video.swift
//  Topvote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result

typealias Medias = [Media]

class Media: Model {
    // MARK: - Properties
    
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var type: String?
    
    var public_id: String?
    
    var version: Double?
    
    var signature: String?
    
    var width: Int?
    
    var height: Int?
    
    var format: String?
    
    var bytes: Int?
    
    var etag: String?
    
    var url: URL?
    
    var secure_url: URL?
    
    var thumbnail: URL?
    
    var audio: AudioInfo?
    
    var video: VideoInfo?
    
    var is_audio: Bool?
    
    var frame_rate: Double?
    
    var bit_rate: Double?
    
    var duration: Double?
    
    var rotation: Double?
    
    // MARK: * Instant methods
    
    //    static let providerClosure = { (target: Entry.API) -> Endpoint<Entry.API> in
    //        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    //        let headerFields = URLRequest.authHeaders(httpMethod: defaultEndpoint.method.rawValue, urlPath: target.path, version: target.version)
    //        let endpointWithHeaders = defaultEndpoint.adding(newHTTPHeaderFields: headerFields)
    //        return endpointWithHeaders
    //    }
    
    static let providerClosure = { (target: Media.API) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        
        var headerFields = URLRequest.authHeaders(httpMethod: defaultEndpoint.method.rawValue, urlPath: target.path, version: target.version)
        
        switch target {
        case .createPhoto:
            headerFields["Content-Type"] = "application/octet-stream"
            break
        case .createVideo:
            headerFields["Content-Type"] = "application/octet-stream"
            break
        }
        
        let endpointWithHeaders = defaultEndpoint.adding(newHTTPHeaderFields: headerFields)
        return endpointWithHeaders
    }
    
    static let stubbingBehavior = { (target: Media.API) -> StubBehavior in
        return .never
    }
    
    static let provider = MoyaProvider<Media.API>(endpointClosure: providerClosure, stubClosure: stubbingBehavior, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Moya.Response.JSONResponseDataFormatter)])
}
