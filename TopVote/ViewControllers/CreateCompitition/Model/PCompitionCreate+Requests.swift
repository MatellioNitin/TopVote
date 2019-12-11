//
//  Competition+Requests.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension PCompitionCreate {
    // MARK: * Instance methods

    // MARK: - Private/Public Competition Method
    // Create Method
    
    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        
        PCompitionCreate.provider.request(PCompitionCreate.API.index(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
               // if let value = data {
                   // let privateCompitionCreate:PCompitionCreates = PCompitionCreate.models(data: value)
                    completion()
              //  } else
            if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            else{
                  completion()
                }
            })
        }
    }
    
    
    static func createPublicComp(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        PCompitionCreate.provider.request(PCompitionCreate.API.userCompetitionCreate(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                }
                else{
                    completion()
                }
//                if let value = data {
//                    let competitions:Competitions = Competition.models(data: value)
//                    completion(competitions)
//                } else if let errorMessage = errorMessage {
//                    error(errorMessage)
//                }
            })
        }
    }
    
    static func createPoll(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        PCompitionCreate.provider.request(PCompitionCreate.API.userPollCreate(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                }
                else{
                    completion()
                }
                //                if let value = data {
                //                    let competitions:Competitions = Competition.models(data: value)
                //                    completion(competitions)
                //                } else if let errorMessage = errorMessage {
                //                    error(errorMessage)
                //                }
            })
        }
    }
    
    static func updatePoll(pollId: String, queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        PCompitionCreate.provider.request(PCompitionCreate.API.updatePoll(queryParams: queryParams, pollId: pollId)) { result in result.handleResponseData(completion: { (errorMessage, _, _) in
            
            if let errorMessage = errorMessage {
                error(errorMessage)
            }
            else{
                completion()
            }
            
            //            if let value = data {
            //                let privateCompitionCreate:PCompitionCreate = PCompitionCreate.create(data: value)!
            //                completion([privateCompitionCreate])
            //            } else if let errorMessage = errorMessage {
            //                error(errorMessage)
            //            }
        })
        }
    }
    // Update Method
    static func updatePrivateComp(compId: String, params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        
        PCompitionCreate.provider.request(PCompitionCreate.API.update(queryParams: params, competitionId: compId)) { result in result.handleResponseData(completion: { (errorMessage, _, _) in
            
            if let errorMessage = errorMessage {
                error(errorMessage)
            }
            else{
                completion()
            }
            
//            if let value = data {
//                let privateCompitionCreate:PCompitionCreate = PCompitionCreate.create(data: value)!
//                completion([privateCompitionCreate])
//            } else if let errorMessage = errorMessage {
//                error(errorMessage)
//            }
        })
        }
    }
    
    
    static func updatePublicComp(compId: String, queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        PCompitionCreate.provider.request(PCompitionCreate.API.userCompetitionUpdate(queryParams: queryParams, competitionId: compId)) { result in result.handleResponseData(completion: { (errorMessage, _, _) in
            if let errorMessage = errorMessage {
                error(errorMessage)
            }
            else{
                completion()
            }
//            if let value = data {
//                let competitions:Competitions = Competition.models(data: value)
//                completion(competitions)
//            } else if let errorMessage = errorMessage {
//                error(errorMessage)
//            }
        })
        }
    }
    
    
    
    
    
    
    
    
//    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: PCompitionCreates) -> Void) {
//
//            PCompitionCreate.provider.request(PCompitionCreate.API.index(queryParams: queryParams)) { result in
//                result.handleResponseData(completion: { (errorMessage, data, token) in
//                    if let value = data {
//                        let privateCompitionCreate:PCompitionCreates = PCompitionCreate.models(data: value)
//                        completion(privateCompitionCreate)
//                    } else if let errorMessage = errorMessage {
//                        error(errorMessage)
//                    }
//                })
//            }
//    }
//
//
//    static func createPublicComp(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Competitions) -> Void) {
//        PCompitionCreate.provider.request(PCompitionCreate.API.userCompetitionCreate(queryParams: queryParams)) { result in
//            result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let value = data {
//                    let competitions:Competitions = Competition.models(data: value)
//                    completion(competitions)
//                } else if let errorMessage = errorMessage {
//                    error(errorMessage)
//                }
//            })
//        }
//    }
//
//    // Update Method
//    static func updatePrivateComp(compId: String, params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: PCompitionCreates) -> Void) {
//
//            PCompitionCreate.provider.request(PCompitionCreate.API.update(queryParams: params, competitionId: compId)) { result in result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let value = data {
//                    let privateCompitionCreate:PCompitionCreate = PCompitionCreate.create(data: value)!
//                    completion([privateCompitionCreate])
//                } else if let errorMessage = errorMessage {
//                    error(errorMessage)
//                }
//            })
//            }
//        }
//
//
//    static func updatePublicComp(compId: String, queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Competitions) -> Void) {
//        PCompitionCreate.provider.request(PCompitionCreate.API.userCompetitionUpdate(queryParams: queryParams, competitionId: compId)) { result in result.handleResponseData(completion: { (errorMessage, data, token) in
//                    if let value = data {
//                        let competitions:Competitions = Competition.models(data: value)
//                        completion(competitions)
//                    } else if let errorMessage = errorMessage {
//                        error(errorMessage)
//                    }
//                })
//                }
//            }
    
}

