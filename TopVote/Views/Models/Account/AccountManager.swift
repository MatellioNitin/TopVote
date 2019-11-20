//
//  AccountManager.swift
//  Topvote
//
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

/// Manager for static variables of Account object. typealias of Account.
typealias AccountManager = Account

// MARK: - Account / Management
extension AccountManager {
    // MARK: * Properties
    
    static var keychain: AppKeychain = {
        return AppKeychain()
    }()
    
    /// The current account, signed in with session.
    
    static var session: Session? {
        didSet {
            sessionToken = session?.token
        }
    }
    
    /// The current session token associated with the account.
    
    static var sessionToken: String?
    
    /// Checks if the session is still valid.
    
    static var isAuthenticated: Bool {
        guard let session = session, let _ = session.token, let _ = session.account else {
            return false
        }
        
        return true
    }
    
    /// Remove any parameters tied to a session, for log out.
    
    static func clearSession() {
        session?.token = nil
        saveSession()
        session = nil
        sessionToken = nil
    }
    
    /// Saves the session, account to ios keychain.
    ///
    /// - Parameter account: the account to store in the keychain.
    
    static func saveSession() {
        guard let session = session, let _ = session.account else {
            return
        }
        
        keychain.updateSession(session)
    }
    
    static func saveSession(for session: AccountManager.Session) {
        keychain.updateSession(session)
    }
    
    /// Fetches the last stored session in the ios key chain.
    ///
    /// - Returns: true if a session was found.
    
    static func fetchLastSession() -> Bool {
        if let lastSession = keychain.fetchLastActiveSession() {
            if lastSession.token != nil {
                session = lastSession
                return true
            }
        }
        
        return false
    }
    
    static func fetchLastSessionEmailAddress() -> String? {
        if let lastSession = keychain.fetchLastActiveSession() {
            return lastSession.account?.email
        }
        
        return nil
    }
    
    static var currentUserLocationInfo: UserLocationInfo = UserLocationInfo(locationInfo: nil, newLocation: nil, addressInfo: nil, stateCode: nil, countryCode: nil, isValidLocation: false)
}
