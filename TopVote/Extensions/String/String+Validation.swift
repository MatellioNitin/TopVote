//
//  String+Validation.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

extension String {
    // MARK: * Email
    
    /// A convenience function for validating a email address
    ///
    /// - Parameter stricterFilter: should the filter apply a more strict filter.
    /// - Returns: true or false if the email address is valid.
    
    func validateEmail(stricterFilter: Bool = false) -> Bool {
        let strictFilterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let laxString = ".+@.+\\.[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = stricterFilter ? strictFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
    
    // MARK: * Password
    
    /// A convenience func for validating a password.
    ///
    /// - Returns: true or false if the password does not meet the requirements. Requirements: { 6 character minmum, one special character, one numerical value, no white spaces. }
    
    func validatePassword() -> (success: Bool, errorMessage: String?) {
        let errorMessage = "Password must contain at least one special character, a numerical value, and be at least 6 characters in length."
        if self.containsWhiteSpace || self.characters.count < 6 {
            return (false, errorMessage)
        }
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        
        if !containsNumber {
            return (false, errorMessage)
        }

        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

        if rangeOfCharacter(from: characterset.inverted) == nil {
            return (false, errorMessage)
        }
        
        return (true, nil)
    }
    
    // MARK: * Username
    
    /// A convenience function for validating user names
    ///
    /// - Returns: true or false if it meets requirements. Requirements: { minimum of 3 characters, no whitespace. }
    
    func validateUsername() -> Bool {
        if self.containsWhiteSpace || self.characters.count < 3 {
            return false
        }
        
        return true
    }
    
    // MARK: * Phone Number
    
    /// Validates a phone number.
    ///
    /// - Returns: true or false if the number is valid.
    
    func validatePhoneNumber() -> Bool {
        if self.containsWhiteSpace {
            return false
        }
        
        let characterRegEx  = ".*[A-Za-z]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", characterRegEx)
        let containsCharacters = testCase.evaluate(with: self)
        
        if containsCharacters {
            return false
        }
        
        let phoneRegex = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phoneTest.evaluate(with: self)
    }
    
    /// Matches string with custom regex.
    ///
    /// - Parameters:
    ///   - regex: the regex to apply to string.
    ///   - text: the string to check.
    /// - Returns: array of strings if strings matches regex.
    
    static func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Matches string with custom regex.
    ///
    /// - Parameters:
    ///   - regex: the regex to apply to string.
    ///   - text: the string to check.
    /// - Returns: array of strings if strings matches regex.
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
