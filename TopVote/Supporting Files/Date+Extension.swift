//
//  Date+Extension.swift
//  GigTrakkr
//
//  Created by Kurt Jensen on 1/1/17.
//  Copyright © 2017 Arbor Apps. All rights reserved.
//

import Foundation

let kMinute = 60
let kDay = kMinute * 24
let kWeek = kDay * 7
let kMonth = kDay * 31
let kYear = kDay * 365

func DateTimeAgoLocalizedStrings(_ key: String) -> String {
    return NSLocalizedString(key, tableName: "DateTimeAgo", bundle: Bundle.main, comment: "")
}

extension Date {
    
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd h:mm a"
        return formatter.string(from: self)
    }
    
    func withoutSeconds() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func withoutHoursMinutesSeconds() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func formattedDateOnly() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        return formatter.string(from: self)
    }
    func formattedDateOnlyForFullYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.string(from: self)
    }
    
    func toJustBeforeMidnight() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.current.date(from: components)!
    }
    
    var timeAgoSimple: String {
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60
        if deltaSeconds < kMinute {
            return stringFromFormat("%%d%@s", withValue: deltaSeconds)
        } else if deltaMinutes < kMinute {
            return stringFromFormat("%%d%@m", withValue: deltaMinutes)
        } else if deltaMinutes < kDay {
            let value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat("%%d%@h", withValue: value)
        } else if deltaMinutes < kWeek {
            let value = Int(floor(Float(deltaMinutes / kDay)))
            return stringFromFormat("%%d%@d", withValue: value)
        } else if deltaMinutes < kMonth {
            let value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat("%%d%@w", withValue: value)
        } else if deltaMinutes < kYear {
            let value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat("%%d%@mo", withValue: value)
        } else {
            let value = Int(floor(Float(deltaMinutes / kYear)))
            return stringFromFormat("%%d%@yr", withValue: value)
        }
    }
    
    var timeAgo: String {
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60
        if deltaSeconds < 5 {
            return DateTimeAgoLocalizedStrings("Just now")
        } else if deltaSeconds < kMinute {
            return stringFromFormat("%%d %@seconds ago", withValue: deltaSeconds)
        } else if deltaSeconds < 120 {
            return DateTimeAgoLocalizedStrings("A minute ago")
        } else if deltaMinutes < kMinute {
            return stringFromFormat("%%d %@minutes ago", withValue: deltaMinutes)
        } else if deltaMinutes < 120 {
            return DateTimeAgoLocalizedStrings("An hour ago")
        } else if deltaMinutes < kDay {
            let value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat("%%d %@hours ago", withValue: value)
        } else if deltaMinutes < (kDay * 2) {
            return DateTimeAgoLocalizedStrings("Yesterday")
        } else if deltaMinutes < kWeek {
            let value = Int(floor(Float(deltaMinutes / kDay)))
            return stringFromFormat("%%d %@days ago", withValue: value)
        } else if deltaMinutes < (kWeek * 2) {
            return DateTimeAgoLocalizedStrings("Last week")
        } else if deltaMinutes < kMonth {
            let value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat("%%d %@weeks ago", withValue: value)
        } else if deltaMinutes < (kDay * 61) {
            return DateTimeAgoLocalizedStrings("Last month")
        } else if deltaMinutes < kYear {
            let value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat("%%d %@months ago", withValue: value)
        } else if deltaMinutes < (kDay * (kYear * 2)) {
            return DateTimeAgoLocalizedStrings("Last Year")
        } else {
            let value = Int(floor(Float(deltaMinutes / kYear)))
            return stringFromFormat("%%d %@years ago", withValue: value)
        }
    }
    
    func stringFromFormat(_ format: String, withValue value: Int) -> String {
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(Double(value)))
        return String(format: DateTimeAgoLocalizedStrings(localeFormat), value)
    }
    
    func getLocaleFormatUnderscoresWithValue(_ value: Double) -> String {
        let localeCode = Locale.preferredLanguages.first
        if localeCode == "ru" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
    
}

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let otherDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: otherDate)
        return (dateComponents.year == otherDateComponents.year) && (dateComponents.month == otherDateComponents.month) && (dateComponents.day == otherDateComponents.day)
    }
}

extension TimeInterval {
    
    var dayComponent: Int {
        return self.hours / 24
    }
    var hours: Int {
        return Int(floor(((self / 60.0) / 60.0)))
    }
    var hourComponent: Int {
        return self.hours % 24
    }
    var minutes: Int {
        return Int(floor(self / 60.0))
    }
    var minuteComponent: Int {
        return minutes - (hours * 60)
    }
    var seconds: Int {
        return Int(floor(self))
    }
    var secondComponent: Int {
        return seconds - (minutes * 60)
    }
    var miliseconds: Int64 {
        return Int64((seconds * 1000) + milisecondComponent)
    }
    var milisecondComponent: Int {
        let (_, fracPart) = modf(self)
        return Int(fracPart * 100)
    }
    
    public func formatted(withSeconds: Bool, withMilliSeconds: Bool = false) -> String {
        let daysString = dayComponent > 0 ? String(dayComponent) + "d " : ""
        let hoursString = hourComponent < 10 ? "0" + String(hourComponent) : String(hourComponent)
        let minutesString = minuteComponent < 10 ? "0" + String(minuteComponent) : String(minuteComponent)
        let secondsString = secondComponent < 10 ? "0" + String(secondComponent) : String(secondComponent)
        var counter = "\(daysString)"+"\(hoursString):\(minutesString)"
        if withSeconds {
            counter += ":\(secondsString)"
        }
        if withMilliSeconds {
            let milisecondsStr = milisecondComponent < 10 ? "0" + String(milisecondComponent) : String(milisecondComponent)
            counter += ".\(milisecondsStr)"
        }
        return counter
    }
}
