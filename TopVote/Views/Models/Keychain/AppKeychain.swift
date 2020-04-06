//
//  AppKeychain.swift
//  Topvote
//
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation
import KeychainAccess

private let defaultKCVersion = "0.0.1"

// MARK: - 🔑🔗🔐 App / Management / KeyChain
/// App Keychain manages interactions between keychain lower level api's

final class AppKeychain {
    // MARK: * Properties
    
    /// keychain identifier.
    
    fileprivate(set) lazy var identifier: String = {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "App"
       // removeAllItemsFromKeychain()
        return bundleIdentifier + ".KCAccess" + "-" + Config.enviroment
    }()
    
    /// the keychain object. see KeychainAccess Framework.
    
    fileprivate(set) lazy var keychain: Keychain = {
        return Keychain(service: self.identifier).synchronizable(true)
    }()
    
    /// the keychain info for the application.
    
    lazy var store: Store = {
        return Store(name: identifier,
                     appVersion: Bundle.main.releaseVersionNumber,
                     appBuildNumber: Bundle.main.buildVersionNumber,
                     keychainVersion: defaultKCVersion,
                     sessions: [AccountManager.Session]())
    }()
    
    /// current accounts stored in keychain.
    
    lazy var sessions: [AccountManager.Session] = {
        return [AccountManager.Session]()
    }()
    
    /// Initializer for AppKeychain object.
    
    init() {
        if let data: Data = keychain[data: identifier] {
            do {
                let storeInfo = try PropertyListDecoder().decode(Store.self, from: data)
               // let versionControl = VersionControl()
                //Nitin
                let shouldClearData = true
                //versionControl.shouldClearData(storeInfo)
                print("AppKeychain:shouldClearData \(shouldClearData)")
                if shouldClearData {
                    removeAllItemsFromKeychain()
                    return
                }
                
                if storeInfo.name != "" {
                    store = storeInfo
                    sessions = store.sessions
                }
            } catch {
                print("Keychain::init::UnarchivingData:error => \(error)")
            }
        } else {
            save()
        }
    }
    
    /// remove all objects stored in the keychain relative to this application.
    
    func removeAllItemsFromKeychain() {
        do {
            let newStore = Store(name: identifier,
                                 appVersion: Bundle.main.releaseVersionNumber,
                                 appBuildNumber: Bundle.main.buildVersionNumber,
                                 keychainVersion: defaultKCVersion,
                                 sessions: [AccountManager.Session]())
            
            let data = try PropertyListEncoder().encode(newStore)
            keychain[data: identifier] = data
            store = newStore
        } catch {
            print("keychain::removeAllItemsFromKeychain::error => \(error)")
        }
    }
    
    /// save the keychain info.
    
    func save() {
        do {
            let data = try PropertyListEncoder().encode(store)
            keychain[data: identifier] = data
        } catch {
            print("keychain::error => \(error)")
        }
    }
}
