//
//  Result+HandleResponse.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import Moya
import Result

/// Extend Moya Result for helper functions used in all models of the application.
extension Result {
    
    /// A convenience function for handling api requests that return only status code. Not JSON returned.
    ///
    /// - Parameter completion: the completion handler called upon handling the response. returns errorMessage if error occured, a status code from the response, a session token if one exists.
    
    func handleResponseStatus(completion: (_ errorMessage: String?, _ statusCode: Int, _ token: String?) -> Void) {
        switch self {
        case let .success(response as Moya.Response):
            do {
                let goodResponse = try response.filterSuccessfulStatusCodes()
                var sessionToken: String?
                if let httpResponse = goodResponse.response {
                    if let token = httpResponse.allHeaderFields["api-session-token"] as? String {
                        sessionToken = token
                    }
                }
                
                completion(nil, response.statusCode, sessionToken)
                
            } catch {
                var didNotifySessionExpire = false
                if response.statusCode == 401 || response.statusCode == 403 {
                    didNotifySessionExpire = true
                    DispatchQueue.main.async {
                      UtilityManager.dismissToSplash()
                        
                        NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                    }
                }
                
                var message: String?
                do {
                    let value = try response.mapDictionary()
                    message = value["message"] as? String
                    
                    if let mess = message, didNotifySessionExpire == false {
                        if mess.lowercased().contains("Your session has expired.") || mess.lowercased().contains("your session has expired.") || mess.lowercased().contains("session token") {
                            DispatchQueue.main.async {
                                
                                UtilityManager.dismissToSplash()
                                NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                            }
                        } else if mess.contains(ValidationError.validationMessage), let errorInfo = value["error"] as? [String: Any] {
                            
                            let validationError = ValidationError(dictionary: errorInfo)
                            if let val = validationError.errorMessage {
                                message = val
                            }
                        }
                    }
                    
                    completion(message, response.statusCode, nil)
                } catch {
                    do {
                        let value = try response.mapString()
                        completion(value, response.statusCode, nil)
                    } catch {
                        completion("Request cannot be completed at this time.", response.statusCode, nil)
                    }
                }
            }
        case .failure:
            completion("Server is not available at this time. Please try again later.", 500, nil)
        default:
            completion("Server is not available at this time. Please try again later.", 500, nil)
        }
    }
    
    /// A convenience function for handling api requests that returned.
    ///
    /// - Parameter completion: the completion handler called upon handling the response. returns errorMessage if error occured, a response.data if exists & success, a session token if one exists.
    
    func handleResponseData(completion: (_ errorMessage: String?, _ data: Data?, _ token: String?) -> Void) {
        switch self {
        case let .success(response as Moya.Response):
            do {
                if response.statusCode < 200 || response.statusCode > 299 {
                    var message: String?
                    let value = try response.mapDictionary()
                    
                    message = value["message"] as? String
                    if let mess = message {
                        if mess.lowercased().contains("Your session has expired.") || mess.lowercased().contains("your session has expired.")  || mess.lowercased().contains("session token") {
                            DispatchQueue.main.async {
                            UtilityManager.dismissToSplash()

                                NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                            }
                        } else if mess.contains(ValidationError.validationMessage), let errorInfo = value["error"] as? [String: Any] {
                            let validationError = ValidationError(dictionary: errorInfo)
                            if let val = validationError.errorMessage {
                                message = val
                            }
                        }
                    }
                    completion(message, nil, nil)
                    return
                }
                
                let goodResponse = try response.filterSuccessfulStatusCodes()
                var sessionToken: String?
                if let httpResponse = goodResponse.response {
                    if let token = httpResponse.allHeaderFields["api-session-token"] as? String {
                        sessionToken = token
                    }
                }
                
                completion(nil, response.data, sessionToken)
            } catch {
                var didNotifySessionExpire = false
                if response.statusCode == 401 || response.statusCode == 403 {
                    didNotifySessionExpire = true
                    DispatchQueue.main.async {
                        UtilityManager.dismissToSplash()

                        NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                    }
                }
                
                var message: String?
                do {
                    let value = try response.mapDictionary()
                    
                    message = value["message"] as? String
                    if let mess = message, didNotifySessionExpire == false {
                        if mess.lowercased().contains("Your session has expired.") || mess.lowercased().contains("your session has expired.")  || mess.lowercased().contains("session token") {
                            DispatchQueue.main.async {
                                UtilityManager.dismissToSplash()

                                NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                            }
                        } else if mess.contains(ValidationError.validationMessage), let errorInfo = value["error"] as? [String: Any] {
                            let validationError = ValidationError(dictionary: errorInfo)
                            if let val = validationError.errorMessage {
                                message = val
                            }
                        }
                    }
                    
                    completion(message, nil, nil)
                } catch {
                    do {
                        let value = try response.mapString()
                        completion(value, nil, nil)
                    } catch {
                        completion("Request cannot be completed at this time.", nil, nil)
                    }
                }
            }
        case let .failure(error):
            print("api error: \(error)")
            completion("Server is not available at this time. Please try again later.", nil, nil)
        default:
            completion("Server is not avai lable at this time. Please try again later.", nil, nil)
        }
    }
    
    /// A convenience function for handling api requests that returned.
    ///
    /// - Parameter completion: the completion handler called upon handling the response. returns errorMessage if error occured, a serialized json if exists, a session token if one exists.
    
    func handleResponseJSON(completion: (_ errorMessage: String?, _ json: Any?, _ token: String?) -> Void) {
        switch self {
        case let .success(response as Moya.Response):
            do {
                let goodResponse = try response.filterSuccessfulStatusCodes()
                var sessionToken: String?
                if let httpResponse = goodResponse.response {
                    if let token = httpResponse.allHeaderFields["api-session-token"] as? String {
                        sessionToken = token
                    }
                }
                
                do {
                    let value = try goodResponse.mapDictionary()
                    completion(nil, value, sessionToken)
                } catch {
                    do {
                        let value = try goodResponse.mapArray()
                        completion(nil, value, sessionToken)
                    } catch {
                        completion("Request cannot be completed at this time.", nil, nil)
                    }
                }
            } catch {
                var didNotifySessionExpire = false
                if response.statusCode == 401 || response.statusCode == 403 {
                    didNotifySessionExpire = true
                    DispatchQueue.main.async {
                        UtilityManager.dismissToSplash()

                        NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                    }
                }
                
                var message: String?
                do {
                    let value = try response.mapDictionary()
                    
                    message = value["message"] as? String
                    if let mess = message, didNotifySessionExpire == false {
                        if mess.lowercased().contains("Your session has expired.") || mess.lowercased().contains("your session has expired.")  || mess.lowercased().contains("session token") {
                            DispatchQueue.main.async {
                                UtilityManager.dismissToSplash()
                                NotificationCenter.default.post(name: Notification.Name.AccountSessionExpired, object: nil)
                            }
                        } else if mess.contains(ValidationError.validationMessage), let errorInfo = value["error"] as? [String: Any] {
                            let validationError = ValidationError(dictionary: errorInfo)
                            if let val = validationError.errorMessage {
                                message = val
                            }
                        }
                    }
                    
                    completion(message, nil, nil)
                } catch {
                    do {
                        let value = try response.mapString()
                        completion(value, nil, nil)
                    } catch {
                        completion("Request cannot be completed at this time.", nil, nil)
                    }
                }
            }
        case .failure:
            completion("Server is not available at this time. Please try again later.", nil, nil)
        default:
            completion("Server is not available at this time. Please try again later.", nil, nil)
        }
    }
}
