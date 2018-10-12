//
//  Account+Requests.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

extension Account {
    // MARK: * Instance methods
    
    /// Saves the current account.
    ///
    /// - Parameters:
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account save.
    
    func save(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        Account.provider.request(Account.API.update(account: self)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    AccountManager.session?.account = self
                    AccountManager.saveSession()
                    completion()
                }
            })
        }
    }
    
    func me(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        Account.provider.request(Account.API.me) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let account: Account = Account.create(data: value) {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name.AccountRefreshed, object: nil)
                    }
                    
                    AccountManager.session?.account = account
                    AccountManager.saveSession()

                    completion()
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    func entries(queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ entries: Entries) -> Void) {
        Account.provider.request(Account.API.entries(queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let entries: Entries = Entry.models(data: value)
                    completion(entries)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    func activities(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ activities: Activities) -> Void) {
        Account.provider.request(Account.API.activities) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let activities: Activities = Activity.models(data: value)
                    completion(activities)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    func followingActivities(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ activities: Activities) -> Void) {
        Account.provider.request(Account.API.followingActivities) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let activities: Activities = Activity.models(data: value)
                    completion(activities)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    /// Account Logout, deletes the current session in the system.
    ///
    /// - Parameters:
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account logout.
    
    func logout(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        Account.provider.request(Account.API.logout()) { result in
            result.handleResponseStatus(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    completion()
                }
            })
        }
    }
   
    /// Account Creation
    ///
    /// - Parameters:
    ///   - params: Requires Following Parameters: `email`, `password`, `phoneNumber`. Optional Parameters: `firstName`, `lastName`, `isTestAccount`
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account create.
    
    static func create(params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ account: Account) -> Void) {
        Account.provider.request(Account.API.create(params)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let account: Account = Account.create(data: value)  {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name.AccountCreated, object: nil)
                    }
                    
                    let session = Session(token: token, date: Date(), account: account, password: nil)
                    AccountManager.session = session
                    AccountManager.saveSession()

                    completion(account)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    /// Account Index, queries accounts.
    ///
    /// - Parameters:
    ///   - accountId: the current account id
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account index/query.
    
    static func findOne(accountId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ account: Account) -> Void) {
        Account.provider.request(Account.API.show(accountId: accountId)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let account: Account = Account.create(data: value) {
                    completion(account)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    /// Account login
    ///
    /// - Parameters:
    ///   - params: Requires Email Address & Password.
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account login.
    
    static func login(params: [String: Any?], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ account: Account) -> Void) {
        let parameters = params
//        parameters["metrics"] = Bundle.main.gatherMetrics()
//        parameters["platform"] = "IOS"
        
        Account.provider.request(Account.API.login(parameters)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let account: Account = Account.create(data: value) {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name.AccountCreated, object: nil)
                    }

                    let session = Session(token: token, date: Date(), account: account, password: nil)
                    AccountManager.session = session
                    AccountManager.saveSession()
                    
                    completion(account)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    /// Not Implemented.
    ///
    /// - Parameters:
    ///   - email: account email address
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account forgot password.
//
//    static func forgotPassword(email: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
////        Account.provider.request(Account.API.forgot(email: email)) { result in
////            result.handleResponse(completion: { (errorMessage, _, _) in
////                if let errorMessage = errorMessage {
////                    error(errorMessage)
////                } else {
////                    completion()
////                }
////            })
////        }
//    }
//
    /// Not Implemented.
    ///
    /// - Parameters:
    ///   - password: the new password
    ///   - code: access code
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account reset password.
    
    static func reset(password: String, code: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
//        Account.provider.request(Account.API.reset(password: password, code: code)) { result in
//            result.handleResponse(completion: { (errorMessage, _, _) in
//                if let errorMessage = errorMessage {
//                    error(errorMessage)
//                } else {
//                    completion()
//                }
//            })
//        }
    }
    
    /// Auth/Access Code Verify
    ///
    /// - Parameters:
    ///   - accountId: the current account id
    ///   - code: the auth code.
    ///   - error: error message if one exists in response object.
    ///   - completion: successful response on account code verify.
    
    static func verifyCode(accountId: String, code: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ account: Account, _ token: String?) -> Void) {
        //var parameters = [String: Any]()
        //parameters["metrics"] = Bundle.main.gatherMetrics()
        //parameters["platform"] = "IOS"
        
//        Account.provider.request(Account.API.verifyCode(accountId: accountId, code: code, params: parameters)) { result in
//            result.handleResponse(completion: { (errorMessage, object, token) in
//                if let errorMessage = errorMessage {
//                    error(errorMessage)
//                } else if let value = object as? [String: Any] {
//                    let account = Account(dictionary: value)
//                    completion(account, token)
//                }
//            })
//        }
    }
    
    static func follow(accountId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ followedAccount: Account) -> Void) {
        Account.provider.request(Account.API.follow(accountId: accountId)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let account: Account = Account.create(data: value)  {
                    completion(account)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    static func forgotPassword(params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion:@escaping () -> Void) {
        Account.provider.request(Account.API.forgotPassword(params)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    completion()
                }
            })
        }
    }
    static func passwordChange(params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion:@escaping () -> Void) {
        Account.provider.request(Account.API.passwordChange(params)) { result in
            result.handleResponseData(completion: { (errorMessage, _, _) in
                if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    completion()
                }
            })
        }
    }
    
    static func confirmPassword(params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping () -> Void) {
        Account.provider.request(Account.API.confirmPassword(params)) { result in
                result.handleResponseData(completion: { (errorMessage, _, _) in
                        if let errorMessage = errorMessage {
                        error(errorMessage)
                        } else {
                            completion()
                            }
            })
        }
    }
    
    
    static func unfollow(accountId: String, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ unfollowedAccount: Account) -> Void) {
        Account.provider.request(Account.API.unfollow(accountId: accountId)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let account: Account = Account.create(data: value) {
                    completion(account)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    static func follows(error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ following: Accounts?, _ followers: Accounts?) -> Void) {
        Account.provider.request(Account.API.follows) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let follow: FollowInterceptor = FollowInterceptor.create(data: value) {
                    
                    let following: Accounts? = follow.following
                    let followers: Accounts? = follow.followers
                    
                    completion(following, followers)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }
    
    static func comments(entryId: String, queryParams: [String: Any]?, error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ comments: Comments) -> Void) {
        Account.provider.request(Account.API.commentsIndex(entryId: entryId, queryParams: queryParams)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data {
                    let comments: Comments = Comment.models(data: value)
                    completion(comments)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    static func createComment(entryId: String, params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: @escaping (_ comment: Comment) -> Void) {
        Account.provider.request(Account.API.commentsCreate(entryId: entryId, params: params)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let value = data, let comment: Comment = Comment.create(data: value) {
                    completion(comment)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                }
            })
        }
    }
    
    // MARK: * Notifications
    
    static func registerForNotifications(params: [String: Any], error: @escaping (_ errorMessage: String) -> Void, completion: ((_ device: TVDevice) -> Void)? = nil) {
        Account.provider.request(Account.API.registerForNotifications(params: params)) { result in
            result.handleResponseData(completion: { (errorMessage, data, token) in
                if let data = data, let device: TVDevice = TVDevice.create(data: data) {
                    completion?(device)
                } else if let errorMessage = errorMessage {
                    error(errorMessage)
                } else {
                    error("Request cannot be completed at this time. Please try again later.")
                }
            })
        }
    }

    static func changeSubscriptionForNotifications(subscribe: Bool, error: @escaping (_ errorMessage: String) -> Void, completion: ((_ device: TVDevice) -> Void)? = nil) {
        if subscribe {
            Account.provider.request(Account.API.subscribeForNotifications) { result in
                result.handleResponseData(completion: { (errorMessage, data, token) in
                    if let data = data, let device: TVDevice = TVDevice.create(data: data) {
                        appDelegate.notificationDevice = device
                        completion?(device)
                    } else if let errorMessage = errorMessage {
                        error(errorMessage)
                    } else {
                        error("Request cannot be completed at this time. Please try again later.")
                    }
                })
            }
        } else {
            Account.provider.request(Account.API.unsubscribeForNotifications) { result in
                result.handleResponseData(completion: { (errorMessage, data, token) in
                    if let data = data, let device: TVDevice = TVDevice.create(data: data) {
                        appDelegate.notificationDevice = device
                        completion?(device)
                    } else if let errorMessage = errorMessage {
                        error(errorMessage)
                    } else {
                        error("Request cannot be completed at this time. Please try again later.")
                    }
                })
            }
        }
    }
}
