//
//  Account+Sort.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/1/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

// MARK: - Account / Sort

extension Array where Element == Account {
    
    /// Sort accounts by created at date field.
    ///
    /// - Parameter sign: sign may be { `==`, `<=`, `>=`, `<`, `>`}
    
    mutating func sortCreatedAt(sign: (Date?, Date?) -> Bool) {
        self = sorted(by: {
            return sign($0.createdAt, $1.createdAt)
        })
    }
    
    /// Sort accounts by created at date field.
    ///
    /// - Parameter comparison: { orderedAscending, orderedSame, orderedDescending }
    
    mutating func sortCreatedAt(comparison: ComparisonResult) {
        self = self.sorted(by: {
            $0.createdAt!.compare($1.createdAt!) == comparison
        })
    }
    
    /// Sort accounts by updated at date field.
    ///
    /// - Parameter sign: sign may be { `==`, `<=`, `>=`, `<`, `>`}
    
    mutating func sortUpdatedAt(signInterval: (Date?, Date?) -> Bool) {
        self = sorted(by: {
            return signInterval($0.updatedAt, $1.updatedAt)
        })
    }
    
    /// Sort accounts by updated at date field.
    ///
    /// - Parameter comparison: { orderedAscending, orderedSame, orderedDescending }
    
    mutating func sortUpdatedAt(comparison: ComparisonResult) {
        self = sorted(by: {
            return $0.updatedAt!.compare($1.updatedAt!) == comparison
        })
    }
    
    /// Sort accounts by first name field.
    ///
    /// - Parameter sign: sign may be { `==`, `<=`, `>=`, `<`, `>`}
    
//    mutating func sortFirstName(sign: (String?, String?) -> Bool) {
//        self = sorted(by: {
//            return sign($0.firstName, $1.firstName)
//        })
//    }
//
//    /// Sort accounts by last name field.
//    ///
//    /// - Parameter sign: sign may be { `==`, `<=`, `>=`, `<`, `>`}
//
//    mutating func sortLastName(sign: (String?, String?) -> Bool) {
//        self = sorted(by: {
//            return sign($0.lastName, $1.lastName)
//        })
//    }
    
    /// Sort accounts by full name field.
    ///
    /// - Parameter sign: sign may be { `==`, `<=`, `>=`, `<`, `>`}
    
//    mutating func sortFullName(sign: (String?, String?) -> Bool) {
//        self = sorted(by: {
//            return sign($0.fullName, $1.fullName)
//        })
//    }
    
    /// Sort accounts by email address field.
    ///
    /// - Parameter sign: sign may be { `==`, `<=`, `>=`, `<`, `>`}
    
    mutating func sortEmail(sign: (String?, String?) -> Bool) {
        self = sorted(by: {
            return sign($0.email, $1.email)
        })
    }
}
