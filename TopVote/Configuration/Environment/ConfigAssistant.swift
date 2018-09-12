//
//  ConfigAssistant.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import UIKit

/// Used for extracting out parameters for Config.

final class ConfigAssistant: NSObject {
    
    /// Dictionary contains all the values used in Config.
    ///
    /// - Returns: informations from Config.plist.
    
    fileprivate class func configurationInfo() -> [String: Any] {
        guard let plistPath: String = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            print("<*===========\n\nMissing Config.plist!!!\n\nSee Configuration > Enviroment > `ConfigAssistant`\n\n=================*>")
            return [String: Any]()
        }
        
        let plistData = FileManager.default.contents(atPath: plistPath)
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            let plistInfo = try PropertyListSerialization.propertyList(from: plistData!, options: .mutableContainersAndLeaves, format: &format) as! [String: Any]
            return plistInfo
        } catch {
            
        }
        
        return [String: Any]()
    }
    
    // MARK: - API
    
    /// Fetchs API Key from configurationInfo
    ///
    /// - Parameter enviroment: the enviroment to extract the key from. { DEV, STAGE, PRODUCTION, LOCAL }
    /// - Returns: api key
    
    class func apiKeyForEnviroment(enviroment: String) -> String {
        let config = ConfigAssistant.configurationInfo()
        let envDict = config[enviroment] as! [String: String]
        return envDict["key"] ?? ""
    }
    
    /// Fetchs API Secret from configurationInfo
    ///
    /// - Parameter enviroment: the enviroment to extract the secret from. { DEV, STAGE, PRODUCTION, LOCAL }
    /// - Returns: api secret.
    
    class func apiSecretForEnviroment(enviroment: String) -> String {
        let config = ConfigAssistant.configurationInfo()
        let envDict = config[enviroment] as! [String: String]
        return envDict["secret"] ?? ""
    }
    
    /// Fetchs API Host from configurationInfo
    ///
    /// - Parameter enviroment: the enviroment to extract the host from. { DEV, STAGE, PRODUCTION, LOCAL }
    /// - Returns: api host.
    
    class func apiHostForEnviroment(enviroment: String) -> String {
       // return "DEV"

        let config = ConfigAssistant.configurationInfo()
        let envDict = config[enviroment] as! [String: String]
        return envDict["host"] ?? ""
    }
    
    /// Fetchs API Version from configurationInfo
    ///
    /// - Parameter enviroment: the enviroment to extract the version from. { DEV, STAGE, PRODUCTION, LOCAL }
    /// - Returns: api version.
    
    class func apiVersionForEnviroment(enviroment: String) -> String {
        let config = ConfigAssistant.configurationInfo()
        let envDict = config[enviroment] as! [String: String]
        return envDict["version"] ?? ""
    }
    
    /// Fetchs API Socket Host from configurationInfo
    ///
    /// - Parameter enviroment: the enviroment to extract the socket host from. { DEV, STAGE, PRODUCTION, LOCAL }
    /// - Returns: api socket host.
    
    class func apiSocketHostForEnviroment(enviroment: String) -> String {
        let config = ConfigAssistant.configurationInfo()
        let envDict = config[enviroment] as! [String: String]
        return envDict["socketHost"] ?? ""
    }
}
