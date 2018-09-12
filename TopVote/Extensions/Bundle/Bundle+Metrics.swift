//
//  Bundle+Metrics.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/8/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
import CoreLocation
import Device
//import ifaddrs

// MARK: - Bundle Metrics.

extension Bundle {
    
    var displayName: String {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let appName: String? = name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        return appName ?? ""
    }
    
    /// The current Version of the application.
    
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// The current Build Number of the application.
    
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /// The users current operating system.
    
    var osVersion: String? {
        return UIDevice.current.systemVersion
    }
    
    /// The users current language set at the system level.
    
    var language: String? {
        let preferredLanguages = NSLocale.preferredLanguages
        if !preferredLanguages.isEmpty {
            let language: String = preferredLanguages[0]
            return language
        }
        
        return nil
    }
    
    /// The users current device model.
    
    var readableDeviceType: String? {
        return Device.version().rawValue
    }
    
    /// The users network Carrier Name, if available.
    
    var carrierName: String? {
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.subscriberCellularProvider {
            if let carrierName = carrier.carrierName {
                return carrierName
            }
        }
        
        return nil
    }
    
    /// The users current netwrok connection type. {LTE, Edge, ect}
    
    var connectionType: String? {
        let networkInfo = CTTelephonyNetworkInfo()
        if let currentRadioAccessTechnology = networkInfo.currentRadioAccessTechnology {
            let connectionType = readableConnectionType(currentRadioAccessTechnology)
            return connectionType
        }
        
        return nil
    }
    
    /// The users ip address. WIFI.
    
    var ipAddress: String? {
        return getWiFiAddress()
    }
    
    /// Fetches users current netwrok connection type readable. {LTE, Edge, ect}
    
    private func readableConnectionType(_ connection: String) -> String {
        var connectionType = "UNKNOWN"
        
        if connection == CTRadioAccessTechnologyGPRS {
            connectionType = "GPRS"
        } else if connection == CTRadioAccessTechnologyEdge {
            connectionType = "Edge"
        } else if connection == CTRadioAccessTechnologyGPRS {
            connectionType = "GPRS"
        } else if connection == CTRadioAccessTechnologyWCDMA {
            connectionType = "WCDMA"
        } else if connection == CTRadioAccessTechnologyHSDPA {
            connectionType = "HSDPA"
        } else if connection == CTRadioAccessTechnologyHSUPA {
            connectionType = "HSUPA"
        } else if connection == CTRadioAccessTechnologyCDMA1x {
            connectionType = "CDMA1x"
        } else if connection == CTRadioAccessTechnologyCDMAEVDORev0 {
            connectionType = "CDMAEVDORev0"
        } else if connection == CTRadioAccessTechnologyCDMAEVDORevA {
            connectionType = "CDMAEVDORevA"
        } else if connection == CTRadioAccessTechnologyCDMAEVDORevB {
            connectionType = "CDMAEVDORevB"
        } else if connection == CTRadioAccessTechnologyeHRPD {
            connectionType = "HRPD"
        } else if connection == CTRadioAccessTechnologyLTE {
            connectionType = "LTE"
        }
        
        return connectionType
    }
    
    /// Return IP address of WiFi interface (en0) as a String, or `nil`
    /// must add `#include <ifaddrs.h>`
    
    private func getIPAddress() -> [String]? {
        var address: String?
        var IPAddressArray: [String] = [String]()
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Convert interface address to a human readable string:
                var addr = interface.ifa_addr.pointee
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
                IPAddressArray.append(address!)
            }
        }
        freeifaddrs(ifaddr)
        
        return IPAddressArray
    }
    
    class func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let ifaname = interface?.ifa_name {
                        // String(cString: (interface?.ifa_name)!)
                        let name: String = String(cString: ifaname)
                        if name == "en0" {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    /// Return IP address of WiFi interface (en0) as a String, or `nil`
    
    private func getWiFiAddress() -> String? {
        var address: String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}

// MARK: - Metrics
extension Bundle {
    
    /// Gathers Metrics about users device, connection details
    ///
    /// - Returns: dictionary { appVersion, appBuildVersion, carrierName, connectionType, device, language, ipAddress, osVersion }
    
    func gatherMetrics() -> [String: Any] {
        var metrics = [String: Any]()
        
        //        if let appVersion = Bundle.main.releaseVersionNumber {
        metrics["appVersion"] = Bundle.main.releaseVersionNumber
        //        }
        
        //        if let appBuildVersion = Bundle.main.buildVersionNumber {
        metrics["appBuildVersion"] = Bundle.main.buildVersionNumber
        //        }
        
        if let carrierName = Bundle.main.carrierName {
            metrics["carrierName"] = carrierName
        }
        
        if let connectionType = Bundle.main.connectionType {
            metrics["connectionType"] = connectionType
        }
        
        if let device = Bundle.main.readableDeviceType {
            metrics["device"] = device
        }
        
        if let language = Bundle.main.language {
            metrics["language"] = language
        }
        
        if let ipAddress = Bundle.main.ipAddress {
            metrics["ipAddress"] = ipAddress
        }
        
        if let osVersion = Bundle.main.osVersion {
            metrics["osVersion"] = osVersion
        }
        
        return metrics
    }
}
