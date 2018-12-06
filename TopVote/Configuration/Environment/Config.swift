//
//  ConfigDEV.swift
//  iOS Foundation
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.

import Foundation

private let _enviromentKey = "DEV"

//private let _enviromentKey = "LOCAL"

/// The Configuration used throughout application for API specific tasks.

struct Config
    
{
    /// returns api enviroment. { DEV, STAGE, PRODUCTION, LOCAL }
    
    static let enviroment: String = _enviromentKey
    
    /// return api host url.
    
    static let host: String = ConfigAssistant.apiHostForEnviroment(enviroment: _enviromentKey)
    
    /// returns api key.
    
    static let apiKey: String = ConfigAssistant.apiKeyForEnviroment(enviroment: _enviromentKey)
    
    /// returns api secret.
    
    static let apiSecret: String = ConfigAssistant.apiSecretForEnviroment(enviroment: _enviromentKey)
    
    /// returns api version.
    
    static let version: String = ConfigAssistant.apiVersionForEnviroment(enviroment: _enviromentKey)
    
    /// return api socket host url.
    
    static let socketHost: String = ConfigAssistant.apiSocketHostForEnviroment(enviroment: _enviromentKey)
    
    /// returns out variables of the Config.
    
    static var description: String {
        return "\n\nConfig ->vvv\nEnviroment: \(enviroment)\nHost: \(host)\nKey: \(apiKey)\nSecret: \(apiSecret)\n\n"
    }
}
