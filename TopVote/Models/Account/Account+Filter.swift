//
//  Account+Filter.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

// MARK: - Account / Filter
extension Array where Element == Account {
    
    /// Filter array of accounts by document id.
    ///
    /// - Parameter id: the document id.
    /// - Returns: accounts matching specified document id.
    
    func filter(_ id: String) -> Account? {
        let filtered = self.filter({
            return $0._id == id
        })
        
        return (filtered.isEmpty == false) ? filtered[0] : nil
    }
    
    /// Filters array of accounts by NSPredicate
    ///
    /// - Parameter predicate: the predicate to filter the array with.
    /// - Returns: accounts that match predicate filter.
    
    func filter(_ predicate: NSPredicate) -> [Account] {
        let filtered: [Account] = filter{ predicate.evaluate(with: $0)}
        return filtered
    }
    
    /// Filter array of accounts by first name.
    ///
    /// - Parameter firstName: the first name associated with the account.
    /// - Returns: accounts matching the first name specified.
    
//    func filterFirstName(_ firstName: String) -> [Account]? {
//        let filtered = self.filter({
//            return $0.firstName == firstName
//        })
//
//        return (filtered.isEmpty == false) ? filtered : nil
//    }
    
    /// Filter array of accounts by last name.
    ///
    /// - Parameter lastName: the last name associated with the account.
    /// - Returns: array of accounts matching last name.
    
//    func filterLastName(_ lastName: String) -> [Account]? {
//        let filtered = self.filter({
//            return $0.lastName == lastName
//        })
//
//        return (filtered.isEmpty == false) ? filtered : nil
//    }
    
    /// Filter array of accounts by email address.
    ///
    /// - Parameter email: the email address associated with the account.
    /// - Returns: account matching the email address specified.
    
    func filterEmail(_ email: String) -> Account? {
        let filtered = self.filter({
            return $0.email == email
        })
        
        return (filtered.isEmpty == false) ? filtered[0] : nil
    }
}
