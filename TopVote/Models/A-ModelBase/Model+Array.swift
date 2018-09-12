//
//  Model+Array.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/5/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

extension Array where Element == Model {
    // MARK: * Filter
    
    /// Filter array of models by document id.
    ///
    /// - Parameter id: the document id.
    /// - Returns: model matching specified document id.
    
    func filterById<T: Model>(_ id: String) -> T? {
        let filtered = self.filter({
            return $0._id == id
        })
        
        return filtered.isEmpty ? nil : filtered[0] as? T
    }
    
    /// Filters array of models by NSPredicate
    ///
    /// - Parameter predicate: the predicate to filter the array with.
    /// - Returns: accounts that match predicate filter.
    
    func filterByPredicate<T: Model>(_ predicate: NSPredicate) -> [T] {
        let filtered: [T] = filter{ predicate.evaluate(with: $0)} as! [T]
        return filtered
    }
    
    // MARK: * Sort
    
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
}
