//
//  Entry+Requests.swift
//  iOS Foundation
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Entry {
    // MARK: * Instance methods
    
    func save(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        Entry.provider.request(Entry.API.update(entry: self)) { result in
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
        guard let entryId = self._id else {
            return
        }
        Entry.provider.request(Entry.API.destroy(entryId: entryId)) { result in
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
        guard let entryId = self._id else {
            return
        }
        Entry.provider.request(Entry.API.vote(params: params, entryId: entryId)) { result in
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
    
    func flag(status: Int?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ flag: Flag) -> Void) {
        let params = [
            "status": status ?? 0
        ]
        guard let entryId = self._id else {
            return
        }
        Entry.provider.request(Entry.API.flag(params: params, entryId: entryId)) { result in
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
    }
    
    static func create(params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ entry: Entry) -> Void) {
        Entry.provider.request(Entry.API.create(params)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let entry: Entry = Entry.create(data: value) {
                    DispatchQueue.main.async {
                        //NotificationCenter.default.post(name: NSNotification.Name.AccountCreated, object: nil)
                    }
                    
                    completion(entry)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    static func findOne(entryId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ entry: Entry) -> Void) {
        Entry.provider.request(Entry.API.show(entryId: entryId)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let entry: Entry = Entry.create(data: value) {
                    completion(entry)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    static func find(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ entries: Entries) -> Void) {
        Entry.provider.request(Entry.API.index(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let entries: Entries = Entry.models(data: value)
                    completion(entries)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
}

