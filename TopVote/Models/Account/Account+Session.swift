//
//  Account+Session.swift
//  Topvote
//
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

func == (lhs: AccountManager.Session, rhs: AccountManager.Session) -> Bool {
    return lhs.account?._id == rhs.account?._id
}

extension AccountManager {
    struct Session: Equatable, StringConvertible {
        // MARK: * Properties
        
        /// The session token for the account.
        
        var token: String?
        
        /// The last date of login for the account.
        
        var date: Date = Date()
        
        /// The current session's account.
        
        var account: Account?
        
        /// The password for the account.
        
        var password: String?
        
        enum CodingKeys: String, CodingKey {
            case token
            case date
            case account
            case password
        }
    }
}

// MARK: - StringConvertible
extension AccountManager.Session {
    var description: String {
        var descr = "\n\(type(of: self))\n"
        
        let mirror = Mirror(reflecting: self)
        
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            var stringVal = String(describing: value)
            if stringVal.contains("Optional(") {
                stringVal = String(stringVal.replacingOccurrences(of: "Optional(", with: "").dropLast())
            }
            descr += "\(name): \(stringVal)\n"
        }
        
        return descr
    }
    
    var debugDescription: String {
        var descr = "\n\(type(of: self))\n"
        
        let mirror = Mirror(reflecting: self)
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            descr += "\(name): \(type(of: value)) = '\(value)'\n"
        }
        
        return descr
    }
}

extension AccountManager.Session: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(date, forKey: .date)
        try container.encode(account, forKey: .account)
        try? container.encode(password, forKey: .password)
    }
}

extension AccountManager.Session: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(Account.self, forKey: .account)
        password = try? values.decode(String.self, forKey: .password)
        do {
            token = try values.decode(String.self, forKey: .token)
            date = try values.decode(Date.self, forKey: .date)
        } catch {
            print("Account::Session::Decoder:Error::\(error)")
        }
    }
}
