//
//  Account+Manager+Location.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 5/29/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import CoreLocation

extension AccountManager {
    
    struct UserLocationInfo {
        var locationInfo: CLPlacemark?
        var newLocation: CLLocation?
        var addressInfo: NSDictionary?
        var stateCode: String?
        var countryCode: String?
        var isValidLocation: Bool = false
        
        init(locationInfo: CLPlacemark?, newLocation: CLLocation?, addressInfo: NSDictionary?,
             stateCode: String?, countryCode: String?, isValidLocation: Bool)
        {
            self.locationInfo = locationInfo
            self.newLocation = newLocation
            self.addressInfo = addressInfo
            self.stateCode = stateCode
            self.countryCode = countryCode
            self.isValidLocation = isValidLocation
        }
    }
}
