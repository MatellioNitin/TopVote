//
//  AppDelegate+Location.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// NOTE: Add property to app delegate.
//lazy var locationManager: ServiceLocationManager? = {
//    return ServiceLocationManager(startUpdatingLocation: false, delegate: self)
//}()

/*
// MARK: - ServiceLocationManagerDelegate
extension AppDelegate: ServiceLocationManagerDelegate {
    var currentLocationStatus: CLAuthorizationStatus  {
        if locationManager != nil {
            return CLLocationManager.authorizationStatus()
        }
        
        return .notDetermined
    }
    
    var isLocationUpdatesAllowed: Bool {
        if currentLocationStatus != .notDetermined && currentLocationStatus != .denied && currentLocationStatus != .restricted {
            return true
        }
        
        return false
    }
    
    func locationServicesDidFinishAuthentication(_ locationServices: ServiceLocationManager,
                                                 manager: CLLocationManager!,
                                                 didChangeAuthorizationStatus status: CLAuthorizationStatus,
                                                 isAuthorized: Bool)
    {
        
    }
    
    func locationServicesDidUpdateLocationsWithLocation(_ locationServices: ServiceLocationManager,
                                                        newLocation: CLLocation)
    {
        
    }
    
    func locationServicesDidUpdateWithLocation(_ locationServices: ServiceLocationManager,
                                               newLocation: CLLocation)
    {
        
    }
    
    func locationServicesDidUpdateWithNearestTenMetersLocation(_ locationServices: ServiceLocationManager,
                                                               newLocation: CLLocation)
    {
        
    }
    
    func locationServicesDidReverseGeocodeLocationWithLocationInfo(_ locationServices: ServiceLocationManager, locationInfo: CLPlacemark, newLocation: CLLocation?, addressInfo: NSDictionary?, DidStartLocationUpdatesCompletionHandler startLocationCompletionHandler: DidStartLocationUpdatesCompletionHandler?, DidFinishUpdatesCompletionHandler completionHandler: UpdatingLocationCompletionHandler?)
    {
        AccountManager.currentUserLocationInfo.locationInfo = locationInfo
        AccountManager.currentUserLocationInfo.newLocation = newLocation
        AccountManager.currentUserLocationInfo.addressInfo = addressInfo
        AccountManager.currentUserLocationInfo.isValidLocation = true
        
        if let info = addressInfo {
            if let countryCode = info["CountryCode"] as? String {
                AccountManager.currentUserLocationInfo.countryCode = countryCode
            }
            
            if let state = info["State"] as? String {
                AccountManager.currentUserLocationInfo.stateCode = state
            }
        }
        
        completionHandler?(true)
        locationManager?.updatingLocationCompletionHandler = nil
        locationManager?.stopLocationUpdates()
    }
    
    func locationServicesDidPauseLocationUpdates(_ locationServices: ServiceLocationManager,
                                                 manager: CLLocationManager!)
    {
        
    }
    
    func locationServicesDidResumeLocationUpdates(_ locationServices: ServiceLocationManager,
                                                  manager: CLLocationManager!)
    {
        
    }
    
    func locationServices(_ locationServices: ServiceLocationManager,
                          manager: CLLocationManager!,
                          didFinishDeferredUpdatesWithError error: Error?)
    {
        
    }
    
    func locationServices(_ locationServices: ServiceLocationManager,
                          manager: CLLocationManager!,
                          didFailWithError error: Error)
    {
        var errorMessage: String?
        locationServices.stopLocationUpdates()
//        if let err: NSError = error as NSError? {
            let clErr: CLError = CLError(_nsError: error as NSError)
            switch clErr.code {
            case .locationUnknown:
                errorMessage = "We were unable to detect your location. Please check your network connection or that you are not in airplane mode."
                break
            case .denied:
                break
            default:
                errorMessage = "We were unable to detect your location. please check your network connection or that you are not in airplane mode."
                break
            }
            
//        }
        
        if let message = errorMessage {
            locationManager?.stopLocationUpdates()
            
            // NOTE: Use LocationError CompletionHandler
            if let rootVC = self.window?.rootViewController {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Location", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    rootVC.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: * Confirm Location
    func confirmLocation(forceUpdate: Bool = true,
                         presentingViewController: UIViewController,
                         startedLocationUpdateHandler locationStartHandler: (() -> Void)?,
                         handler: ((UIAlertController?, Bool?) -> Void)!) {
        func checkLocation() {
            if forceUpdate == true {
                locationManager?.authorizationStatus = .notDetermined
                locationManager?.stopLocationUpdates()
                AccountManager.currentUserLocationInfo  = AccountManager.UserLocationInfo(locationInfo: nil,
                                                                                                        newLocation: nil,
                                                                                                        addressInfo: nil,
                                                                                                        stateCode: nil,
                                                                                                        countryCode: nil,
                                                                                                        isValidLocation: false)
            }
            
            if currentLocationStatus == .denied {
                let alert = UIAlertController(title: "Attention", message: "You denied access to location updates. Please go to settings app to allow location usage.", preferredStyle: UIAlertControllerStyle.alert)
                
                let settingsAction = UIAlertAction(title: "Go to Settings App", style: .default, handler: { (_) in
                    guard let bundleIdentifier: String = Bundle.main.bundleIdentifier else {
                        return
                    }
                    
                    if let url = URL(string: UIApplicationOpenSettingsURLString + bundleIdentifier) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                )
                alert.addAction(settingsAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                    appDelegate.locationManager?.updatingLocationCompletionHandler = nil
                }
                )
                alert.addAction(cancelAction)
                handler(alert, false)
                
                return
            }
            
            if locationManager?.authorizationStatus == .notDetermined {
                locationManager?.startLocationUpdates(StartedLocationUpdatesCompletionHandler: { (_) in
                    
                }, ErrorCompletionHandler: { (error) in
                    
                    self.locationManager?.updatingLocationCompletionHandler = nil
                    self.locationManager?.didStartLocationUpdatesCompletionHandler = nil
                    
                    let alert = UIAlertController(title: "Attention", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    handler(alert, false)
                    return
                    
                }, CompletionHandler: { (_) in
                    if appDelegate.locationManager?.authorizationStatus == .denied {
                        let alert = UIAlertController(title: "Attention", message: "You denied access to location updates. Please go to settings app to allow location usage.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let settingsAction = UIAlertAction(title: "Go to Settings App", style: .default, handler: { (_) in
                            guard let bundleIdentifier: String = Bundle.main.bundleIdentifier else {
                                return
                            }
                            
                            if let url = URL(string: UIApplicationOpenSettingsURLString + bundleIdentifier) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                        )
                        alert.addAction(settingsAction)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                            appDelegate.locationManager?.updatingLocationCompletionHandler = nil
                        }
                        )
                        alert.addAction(cancelAction)
                        handler(alert, false)
                        
                        return
                    }
                    
                    handler(nil, AccountManager.currentUserLocationInfo.isValidLocation)
                })
                
                return
            } else if appDelegate.locationManager?.authorizationStatus == .denied {
                let alert = UIAlertController(title: "Attention", message: "You denied access to location updates. Please go to settings app to allow location usage.", preferredStyle: UIAlertControllerStyle.alert)
                
                let settingsAction = UIAlertAction(title: "Go to Settings App", style: .default, handler: { (_) in
                    guard let bundleIdentifier: String = Bundle.main.bundleIdentifier else {
                        return
                    }
                    
                    if let url = URL(string: UIApplicationOpenSettingsURLString + bundleIdentifier) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                )
                alert.addAction(settingsAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                    appDelegate.locationManager?.updatingLocationCompletionHandler = nil
                }
                )
                alert.addAction(cancelAction)
                
                handler(alert, false)
                return
            }
            
            handler(nil, AccountManager.currentUserLocationInfo.isValidLocation)
        }
        
        checkLocation()
    }
}
*/
