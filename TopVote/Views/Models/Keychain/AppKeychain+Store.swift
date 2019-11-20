//
//  AppKeychain+Store.swift
//  Topvote
//
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

extension AppKeychain {
    struct Store: Codable {
        // MARK: * Properties
        
        var name: String
        
        var appVersion: String
        
        var appBuildNumber: String
        
        var keychainVersion: String
        
        var sessions: [AccountManager.Session]
        
        var lastSession: AccountManager.Session?
        
        init(name: String, appVersion: String, appBuildNumber: String, keychainVersion: String, sessions: [AccountManager.Session], lastSession: AccountManager.Session? = nil) {
            self.name = name
            self.appVersion = appVersion
            self.appBuildNumber = appBuildNumber
            self.keychainVersion = keychainVersion
            self.sessions = sessions
            self.lastSession = lastSession
        }
    }
}
