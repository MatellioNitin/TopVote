//
//  StringRawRepresentable.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/5/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

protocol StringRawRepresentable {
    var stringRawValue: String { get }
}

extension StringRawRepresentable
where Self: RawRepresentable, Self.RawValue == String {
    var stringRawValue: String {
        return rawValue
        
    }
}

protocol ValueAsAnyable {
    func valueAsAny() -> Any
}

extension ValueAsAnyable where Self: RawRepresentable {
    func valueAsAny() -> Any {
        return rawValue as Any
    }
}
