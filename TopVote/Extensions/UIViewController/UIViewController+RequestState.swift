//
//  UIViewController+RequestState.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 7/31/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import UIKit

/// the request key for retainment.
private var requestStateAssociationKey: UInt8 = 0

/// UIViewController for handling api request states, loading, errors, finished.

extension UIViewController {
    
    /// The request state of the view controller. Use for when a view controller handles requests against api.
    ///
    /// - loading: the view controller is current loading the data from api.
    /// - error: a error occured for the request made against the api.
    /// - finished: the request has finished successfully.
    
    enum RequestState {
        
        /// - loading: the view controller is current loading the data from api.

        case loading

        /// - error: a error occured for the request made against the api.

        case error(String?)
        
        /// - finished: the request has finished successfully.

        case finished
    }
    
    /// The request state of UIViewController.
    
    var requestState: RequestState {
        get {
            return (objc_getAssociatedObject(self, &requestStateAssociationKey) as? RequestState) ?? .loading
        }
        set(newValue) {
            objc_setAssociatedObject(self, &requestStateAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
