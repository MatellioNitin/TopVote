//
//  Video+API.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/24/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import UIKit
import Moya

// MARK: - Entry / API
extension Media {
    enum API {
        case createPhoto(url: URL)
        case createVideo(url: URL)
    }
}

// MARK: - Video / API / TargetType
extension Media.API: TargetType {
    /// The path to be appended to `baseURL` to form the full `URL`.
    
    public var path: String {
        switch self {
        case .createPhoto:
            return "/photos/me"
        case .createVideo:
            return "/videos/me"
        }
    }
    
    /// The HTTP method used in the request.
    
    public var method: Moya.Method {
        switch self {
        case .createPhoto, .createVideo:
            return .post
        }
    }
    
    /// The parameters to be encoded in the request.
    func params() -> [String : Any]? {
        return nil
    }
    
    func encodingType() -> ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case let .createVideo(url):
            return .uploadFile(url)
        case let .createPhoto(url):
            return .uploadFile(url)
        }
    }
}

