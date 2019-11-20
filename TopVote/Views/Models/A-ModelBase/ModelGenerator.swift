//
//  ModelGenerator.swift
//  Topvote
//
//  Created by Benjamin Stahlhood on 5/5/18.
//  Copyright © 2018 Top, Inc. All rights reserved.
//

import Foundation

typealias StringConvertible = CustomStringConvertible & CustomDebugStringConvertible

func == <T: ModelGenerator>(lhs: T, rhs: T) -> Bool {
    return lhs.data == rhs.data
}

protocol ModelGenerator: Codable, Equatable, StringConvertible {
    static func models<T: ModelGenerator>(data: Data) -> [T]
    
    static func dictionaries<T: ModelGenerator>(array: [T], excluded: [String]) -> [[String: Any]]
    
    static func create<T: ModelGenerator>(data: Data) -> T?
    
    static func dictionary<T: ModelGenerator>(model: T, excluded: [String]) -> [String: Any]
    
    static func data<T: ModelGenerator>(model: T, excluded: [String]) -> Data?
    
    mutating func initialized()
    
    var excluded: [String] { get }
}

// MARK: - StringConvertible
extension ModelGenerator {
    var excluded: [String] {
        return ["excluded"]
    }
    
    var description: String {
        var descr = "\n\(type(of: self))\n"
        
        let mirror = Mirror(reflecting: self)
        
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            var stringVal = String(describing: value)
            if stringVal.contains("Optional(") {
                stringVal = String(stringVal.replacingOccurrences(of: "Optional(", with: "").dropLast())
            }
            descr += "\(name): \(stringVal)\n"
        }
        
        return descr
    }
    
    var debugDescription: String {
        var descr = "\n\(type(of: self))\n"
        
        let mirror = Mirror(reflecting: self)
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            descr += "\(name): \(type(of: value)) = '\(value)'\n"
        }
        
        return descr
    }
}

// MARK: - Initializers
extension ModelGenerator {
    
    
    /// Initializer for generic array of Models.
    ///
    /// - Parameter array: a array of [[String: Any]] type.
    /// - Returns: Generic Array of Models [<T: Model>]
    
    static func models<T: ModelGenerator>(data: Data) -> [T] {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(Date.serverDateFormatter)
            var models = try decoder.decode([T].self, from: data)
            for i in 0..<models.count {
                var model = models[i]
                model.initialized()
                models[i] = model
            }
            
            return models
        } catch {
            // print("error trying to convert data to Model")
            // print(error)
            assert(1 == 2, "error trying to convert data to Model => \(error)")
            return [T]()
        }
    }
    
    /// Converts a Model array to array of Dictionaries. Type: [[String: Any]]
    /// - Parameter array: the array to convert.
    /// - Returns: array of dictionaries. [[String: Any]].
    
    static func dictionaries<T: ModelGenerator>(array: [T], excluded: [String] = [String]()) -> [[String: Any]] {
        return array.map{ dictionary(model: $0, excluded: excluded) }
    }
    
    static func create<T: ModelGenerator>(data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(Date.serverDateFormatter)
            var model = try decoder.decode(T.self, from: data)
            model.initialized()
            return model
        } catch {
            //            print("error trying to convert data to Model")
                 print(error)
            // assert(1 == 2, "error trying to convert data to Model => \(error)"); nikhil
            return nil
        }
    }
    /// Converts a Model to Dictionary type. [String: Any]
    ///
    /// - Parameter model: the model to convert.
    /// - Returns: dictionary [String: Any].
    static func dictionary<T: ModelGenerator>(model: T, excluded: [String] = [String]()) -> [String: Any] {
        var aDictionary = [String: Any]()
        
        let mirror = Mirror(reflecting: model)
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            if !excluded.contains(name) && !model.excluded.contains(name) {
                aDictionary[name] = value
            }
        }
        
        return aDictionary
    }
    
    static func dictionaryEncoded<T: ModelGenerator>(model: T, excluded: [String] = [String]()) -> [String: Any] {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(Date.serverDateFormatter)
            let data = try encoder.encode(model)
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            //            print("dataAsJSON: \(dataAsJSON)")
            if let value = dataAsJSON as? [String: Any] {
                return value
            }
        } catch {
            //            print("error trying to convert data to Model")
            //            print(error)
            assert(1 == 2, "error trying to convert data to Model => \(error)")
        }
        
        return [String: Any]()
    }
    
    static func data<T: ModelGenerator>(model: T, excluded: [String]) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(Date.serverDateFormatter)
        do {
            let data = try encoder.encode(model)
            return data
        } catch {
            //            print("error trying to convert data to Model")
            //            print(error)
            assert(1 == 2, "error trying to convert data to Model => \(error)")
            return nil
        }
    }
    
    mutating func initialized() { }
    
    mutating func mergeUpdated<T: ModelGenerator>(_ updated: T) { }
}

extension ModelGenerator {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var data: Data {
        return try! JSONEncoder().encode(self)
    }
    
    var dictionary: [String: Any] {
        var dictionary = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
        for exclude in excluded {
            dictionary[exclude] = nil
        }
        return dictionary
    }
}
