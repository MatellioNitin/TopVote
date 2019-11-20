//
//  Video+Requests.swift
//  Topvote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Media {
    static func uploadVideo(_ url: URL, progress: @escaping (_ currentProgress: Double, _ completed: Bool) -> Void, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ media: Media) -> Void) {
        Media.provider.request(Media.API.createVideo(url: url), callbackQueue: nil, progress: { (upload) in
            progress(upload.progress, upload.completed)
        }) { (result) in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let media: Media = Media.create(data: value) {
                    media.type = "VIDEO"
                    completion(media)
                } else {
                    error(errorMessage!)
                }
            })
        }
    }
    
    static func uploadPhoto(_ url: URL, progress: @escaping (_ currentProgress: Double, _ completed: Bool) -> Void, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ media: Media) -> Void) {
        Media.provider.request(Media.API.createPhoto(url: url), callbackQueue: nil, progress: { (upload) in
            progress(upload.progress, upload.completed)
        }) { (result) in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let media: Media = Media.create(data: value) {
                    media.type = "IMAGE"
                    completion(media)
                } else {
                    error(errorMessage!)
                }
            })
        }
    }
}
