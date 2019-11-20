//
//  Idea+Requests.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/29/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Idea {
    // MARK: * Instance methods
    
    func save(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        Idea.provider.request(Idea.API.update(idea: self)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    completion()
                }
            })
        }
    }
    
    func delete(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        guard let ideaId = self._id else {
            return
        }
        Idea.provider.request(Idea.API.destroy(ideaId: ideaId)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    completion()
                }
            })
        }
    }
    
    func vote(numberOfVotes: Int, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        let params = [
            "votes": numberOfVotes
        ]
        guard let ideaId = self._id else {
            return
        }
        Idea.provider.request(Idea.API.vote(params: params, ideaId: ideaId)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    if var valueVotes = self.valueVotes {
                        valueVotes += numberOfVotes
                        self.valueVotes = valueVotes
                    }
                    if var numberOfVotes = self.numberOfVotes {
                        numberOfVotes += 1
                        self.numberOfVotes = numberOfVotes
                    }
                    self.hasVoted = true
                    completion()
                }
            })
        }
    }
    
    static func create(params: [String: String?], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ idea: Idea) -> Void) {
        Idea.provider.request(Idea.API.create(params)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let idea: Idea = Idea.create(data: value) {
                    completion(idea)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    static func findOne(ideaId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ entry: Entry) -> Void) {
        Idea.provider.request(Idea.API.show(ideaId: ideaId)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let entry: Entry = Entry.create(data: value) {
                    completion(entry)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ ideas: Ideas) -> Void) {
        Idea.provider.request(Idea.API.index(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let ideas: Ideas = Idea.models(data: value)
                    completion(ideas)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
}

