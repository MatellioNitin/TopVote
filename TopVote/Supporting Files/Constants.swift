//
//  Constants.swift
//  TopVote
//
//  Created by Kurt Jensen on 8/5/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    enum Server {
        case local, staging, production
        
        var apiURL: String {
            switch self {
            case .local:
                return "http://10.0.0.180:1337"
            default:
                return "https://topvote-server.herokuapp.com"
            }
        }
        
        var refreshTime: TimeInterval {
            switch self {
            case .local:
                return 15
            default:
                return 60
            }
        }
        
    }

    static let server: Server = .local
    
    static var COMPETITIONS_REFRESH_TIME: TimeInterval {
        return server.refreshTime
    }
    
    static var parseURL: String {
        return "\(server.apiURL)/parse/"
    }
    
    class Instagram {
        static let clientID = "af80e73119464a5cb813ef2c816d66f6"
        static let clientSecret = "07cda7f119834f43915f6c1c73bf5ad6"
    }
    
    class Parse {
        static let applicationId = "topVoteAppId"
        static let clientKey = "topVoteClientId"
    }
    
    class Twitter {
        static let consumerKey = "qwsXtqv7rTHiNvdmBXx2AuyIQ"
        static let consumerSecret = "4AyhsARMZalugZjgYhNjWJoqFSqPMSfcz04JuesoNwRl4u1UtP"
    }
    
    class FilePicker {
        static let apiKey = "AwYHg3o2vQtutN8UsMzKfz"
    }
    
}
