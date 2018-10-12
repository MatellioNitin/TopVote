//
//  AppKeychain+VersionControl.swift
//  Topvote
//
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

extension AppKeychain {
    struct VersionControl {
        // MARK: * Properties
        
        fileprivate(set) lazy var plistInfo: [String: Any] = {
            guard let plistPath: String = Bundle.main.path(forResource: "AppKeychain", ofType: "plist") else {
                return [String: Any]()
            }
            
            let plistData = FileManager.default.contents(atPath: plistPath)
            var format = PropertyListSerialization.PropertyListFormat.xml
            
            do {
                let info = try PropertyListSerialization.propertyList(from: plistData!, options: .mutableContainersAndLeaves, format: &format) as! [String: Any]
                return info
            } catch { }
            
            return [String: Any]()
        }()
        
        var pattern: Pattern = .none
        
        var keychainVersion: String?
        
        
        // MARK: * Initialization
        
        init() {
            keychainVersion = plistInfo["version"] as? String
            
            let useAppVersion = plistInfo["clearDataOnNewVersion"] as? Bool ?? false
            let useBuildNumber = plistInfo["clearDataOnNewBuildNumber"] as? Bool ?? false
            let useKeychainVersion = plistInfo["clearDataOnNewKeychainVersion"] as? Bool ?? false
            
            if useAppVersion {
                pattern = .appVersion
            } else if useBuildNumber {
                pattern = .appBuildNumber
            } else if useKeychainVersion {
                pattern = .keychainVersion
            }
        }
        
        init(pattern: Pattern) {
            self.pattern = pattern
        }
        
        /// Should clear data from keychain based on pattern. Patterns: appVersion, appBuildNumber, keychainVersion, none
        
        func shouldClearData(_ store: AppKeychain.Store) -> Bool {
            //return true
            let appVersion = store.appVersion
            let appBuildNumber = store.appBuildNumber
            let storeKeychainVersion = store.keychainVersion
            
            switch pattern {
            case .none:
                return false
            case .appVersion:
                return (appVersion != Bundle.main.releaseVersionNumber)
            case .appBuildNumber:
                return (appBuildNumber != Bundle.main.buildVersionNumber)
            case .keychainVersion:
                return (keychainVersion != storeKeychainVersion)
            }
        }
    }
}

extension AppKeychain.VersionControl {
    enum Pattern {
        case appVersion, appBuildNumber, keychainVersion, none
    }
}
