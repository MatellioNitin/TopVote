//
//  Date+Server.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

/// Extend Date for Sever Dates formatting.

extension Date {

    /// Formats the server date. Format: `yyyy-MM-dd'T'HH:mm:ss.SSSZ`
    
    static var serverDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
    
    /// Formats a date for display used throughout application.
    
    private static var monthDayYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }
    
    private static var monthDayYear2Formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        return formatter
    }
    
    private static var monthDayYearTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy @ h:mm a"
        return formatter
    }
    
    /// returns a date from a string with format of `yyyy-MM-dd'T'HH:mm:ss.SSSZ`
    ///
    /// - Parameter from: string date
    /// - Returns: Date object, nil if the date does not match the format or if the from parameter is nil.
    
    static public func serverDate(from: String?) -> Date? {
        if let fromString = from {
            return serverDateFormatter.date(from: fromString)
        }
        return nil
    }
    
    /// Returns a string representation of Date with format of `yyyy-MM-dd'T'HH:mm:ss.SSSZ` from the sever.
    ///
    /// - Parameter from: Date Object to convert to string.
    /// - Returns: string representation of Date Object, nil if Date object is nil or cannot be formatted.
    
    static public func serverString(from: Date?) -> String? {
        if let fromDate = from {
            return serverDateFormatter.string(from: fromDate)
        }
        return nil
    }
    
    /// Returns a string representation of Date with format of `MM/dd/yy` from the Date object.
    ///
    /// - Parameter from: Date Object to convert to string `month/day/year`.
    /// - Returns: string representation of Date Object, nil if Date object is nil or cannot be formatted.
    
    static public func monthDayYear(from: Date?) -> String? {
        if let fromDate = from {
            return monthDayYearFormatter.string(from: fromDate)
        }
        return nil
    }
    
    static public func monthDayYear2(from: Date?) -> String? {
        if let fromDate = from {
            return monthDayYear2Formatter.string(from: fromDate)
        }
        return nil
    }
    
    static public func monthDayYearTime(from: Date?) -> String? {
        if let fromDate = from {
            return monthDayYearTimeFormatter.string(from: fromDate)
        }
        return nil
    }
}
