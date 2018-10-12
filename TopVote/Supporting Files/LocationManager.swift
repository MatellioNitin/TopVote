//
//  LocationManager.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static var instance = LocationManager()
    var locationManager = CLLocationManager()
    
    static let stateAbbreviations = ["alabama":"AL","alaska":"AK","arizona":"AZ","arkansas":"AR","california":"CA","colorado":"CO","connecticut":"CT","delaware":"DE","district of columbia":"DC","florida":"FL","georgia":"GA","hawaii":"HI","idaho":"ID","illinois":"IL","indiana":"IN","iowa":"IA","kansas":"KS","kentucky":"KY","louisiana":"LA","maine":"ME","maryland":"MD","massachusetts":"MA","michigan":"MI","minnesota":"MN","mississippi":"MS","missouri":"MO","montana":"MT","nebraska":"NE","nevada":"NV","new hampshire":"NH","new jersey":"NJ","new mexico":"NM","new york":"NY","north carolina":"NC","north dakota":"ND","ohio":"OH","oklahoma":"OK","oregon":"OR","pennsylvania":"PA","rhode island":"RI","south carolina":"SC","south dakota":"SD","tennessee":"TN","texas":"TX","utah":"UT","vermont":"VT","virginia":"VA","washington":"WA","west virginia":"WV","wisconsin":"WI","wyoming":"WY"]

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
        start()
    }

    func start() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            start()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // ?
    }

    func getLocationAndName(_ completion: @escaping (_ success: Bool, _ location: CLLocation?, _ locationName: String?) -> Void) {
        
        let location = locationManager.location
        if let location = location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if let placemark = placemarks?.first {
                    completion(true, location, placemark.locationName())
                }
            })
        } else {
            completion(false, nil, nil)
        }
    }

}

extension CLPlacemark {
    func locationName() -> String {
        var string = ""
        if let locality = locality {
            string += locality
        }
        if let administrativeArea = administrativeArea {
            string += ", \(administrativeArea)"
        } else if let country = country {
            string += ", \(country)"
        }
        return string
    }
}
