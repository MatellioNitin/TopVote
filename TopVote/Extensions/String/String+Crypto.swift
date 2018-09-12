//
//  String+Crypto.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import CommonCrypto 

extension String {
    
    /// A convenience function for hasing a key using HmacSha256.
    ///
    /// - Parameter key: the api key to use
    /// - Returns: hased value of the key.
    
    func stringDigestUsingHmacSha256WithKey(key: String) -> String {
        let s = self.cString(using: .utf8)
        let k = key.cString(using: .utf8)
        
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        let keyLength = Int(key.lengthOfBytes(using: .utf8))
        let strLength = Int(self.lengthOfBytes(using: .utf8))//String.Encoding(rawValue: String.Encoding.utf8.rawValue)))
        
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA256)
        
        CCHmac(algorithm, k!, keyLength, s, strLength, digest)
        
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", digest[i])
        }
        
        digest.deinitialize(count: digestLength)
        
        return String(hash)
    }
}
