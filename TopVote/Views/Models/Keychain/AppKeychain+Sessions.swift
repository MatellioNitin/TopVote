//
//  AppKeychain+Sessions.swift
//  Topvote
//
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

extension AppKeychain {
    /// Fetches a account stored in keychain matching the id.
    ///
    /// - Parameter id: the id of the account object.
    /// - Returns: AccountClass instance.
    
    func fetchSession(_ id: String) -> AccountManager.Session? {
       // return nil

        if !sessions.isEmpty {
            let filtered = sessions.filter({
                return $0.account?._id == id
            })
            
            if !filtered.isEmpty {
                return filtered.first
            }
        }
        
        return nil
    }
    
    /// Fetches the last active account.
    ///
    /// - Returns: AccountClass instance.
    
    func fetchLastActiveSession() -> AccountManager.Session? {
        if let session = store.lastSession {
            return session
        }
        
        if !sessions.isEmpty {
            let sorted = sessions.sorted(by: {
                return $0.date > $1.date
            })
            
            return sorted.first
        }
        
        return nil
    }
    
    /// Updates a account stored in the keychain.
    ///
    /// - Parameter account: AccountClass instance.
    
    func updateSession(_ session: AccountManager.Session) {
        var session = session
        
        guard let _ = session.account else {
            return
        }
        
        if !sessions.isEmpty {
            if let index = sessions.index(where: {$0.account?._id == session.account?._id}) {
                session.date = Date()
                let oldSession = sessions[index]
                if session.password == nil {
                    session.password = oldSession.password
                }
                                
                sessions[index] = session
                store.sessions = sessions
                store.lastSession = session
                store.lastSession?.token = AccountManager.sessionToken
                save()
                
                return
            }
        }
        
        store.lastSession = session
        store.lastSession?.token = AccountManager.sessionToken
        sessions.append(session)
        store.sessions = sessions
        save()
    }
}
