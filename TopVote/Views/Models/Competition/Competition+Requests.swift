//
//  Competition+Requests.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Competition {
    // MARK: * Instance methods
    
    static func findOne(competitionId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competition: Competition) -> Void) {
        Competition.provider.request(Competition.API.show(competitionId: competitionId)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let competition: Competition = Competition.create(data: value) {
                    completion(competition)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    
    static func findPrivate(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Competitions) -> Void) {
        Competition.provider.request(Competition.API.privateCompetition(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let competitions: Competitions = Competition.models(data: value)
                    completion(competitions)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
        

    
    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Competitions) -> Void) {
        Competition.provider.request(Competition.API.index(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let competitions: Competitions = Competition.models(data: value)
                    completion(competitions)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    static func findHall(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Competitions) -> Void) {
        Competition.provider.request(Competition.API.indexHall(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let competitions: Competitions = Competition.models(data: value)
                    completion(competitions)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
        
    }
    
    
    
//    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ competitions: Competitions) -> Void) {
//        Competition.provider.request(Competition.API.index(queryParams: queryParams)) { result in
//            result.handleResponseData(completion: { (errorMessage, data, token) in
//                if let value = data {
//                    let competitions: Competitions = Competition.models(data: value)
//                    completion(competitions)
//                } else if let errorMessage = errorMessage {
//                    error(errorMessage)
//                }
//            })
//        }
//    }
    
    


