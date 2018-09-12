//
//  Competition+Requests.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Poll {
    // MARK: * Instance methods
    
    static func getPoll(pollID: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ poll: Poll) -> Void) {
        Poll.provider.request(Poll.API.getPoll(getPollId: pollID)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let pollObj: Poll = Poll.create(data: value)!
                  //  let pollObj: Poll = Poll.models(data: value)
                    completion(pollObj)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    static func setPoll(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ polls: Poll) -> Void) {
        Poll.provider.request(Poll.API.setPoll(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                     let pollObj: Poll = Poll.create(data: value)!
                    completion(pollObj)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    
//    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competition: Polls) -> Void) {
//        Poll.provider.request(Poll.API.index(queryParams: queryParams)) { result in
//            result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let value = data, let pollObj: Poll = Poll.create(data: value) {
//                    completion(pollObj)
//            
//                    completion(categorys)
//                } else if let errorMessage = errorMessage {
//                    error(errorMessage)
//                }
//            })
//        }
//    }
}

