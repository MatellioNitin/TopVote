//
//  Competition+Requests.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.

import Foundation

extension Category {
    // MARK: * Instance methods
    
//    static func findOne(competitionId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competition: Competition) -> Void) {
//        Competition.provider.request(Competition.API.show(competitionId: competitionId)) { result in
//            result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let value = data, let competition: Competition = Competition.create(data: value) {
//                    completion(competition)
//                } else if let errorMessage = errorMessage {
//                    error(errorMessage)
//                }
//            })
//        }
//    }

    
    static func deepLink(deepLink: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: PCompitionCreates) -> Void) {
        Category.provider.request(Category.API.deepLink(deepLinkId: deepLink)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let privateCompitionCreate:PCompitionCreates = PCompitionCreate.models(data: value)
                    completion(privateCompitionCreate)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }

    static func p2pCheck(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ flag: Flag) -> Void) {
        Category.provider.request(Category.API.p2pCheck()) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                    if let errorMessage = errorMessage {
                        error(errorMessage)
                    } else {
                        if let value = data, let flag: Flag = Flag.create(data: value) {
                            completion(flag)
                        }
                    }
                })
            }
            
            
 //       result in
//            result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let errorMessage = errorMessage {
//                    error(errorMessage)
//                } else {
//                    if let value = data, let flag: Flag = Flag.create(data: value) {
//                        completion(flag)
//                    }
//                }
//            })
//        }
    }
    
    
    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Categorys) -> Void) {
        Category.provider.request(Category.API.index(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let categorys: Categorys = Category.models(data: value)
                    completion(categorys)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
}

