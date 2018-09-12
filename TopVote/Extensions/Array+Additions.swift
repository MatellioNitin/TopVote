//
//  Array+Additions.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 8/9/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}
