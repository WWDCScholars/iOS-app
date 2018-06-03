//
//  LocationAuthorizationStatusManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

internal final class LocationStatusManager {
    
    // MARK: - Private Properties
    
    private let viewController: UIViewController
    private let locationManager: CLLocationManager
    
    // MARK: - Lifecycle
    
    internal init(viewController: UIViewController, locationManager: CLLocationManager) {
        self.viewController = viewController
        self.locationManager = locationManager
    }
    
    // MARK: - Internal Functions
    
    internal func handleAuthorizationFailure() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authorizationStatus == .restricted {
            self.presentAuthorizationRestrictedAlertView()
            return
        }
        
        if authorizationStatus == .denied {
            self.presentAuthorizationDeniedAlertView()
            return
        }
    }
    
    internal func handleLocationServicesDisabled() {
        self.presentLocationServicesDisabledAlertView()
    }
    
    // MARK: - Private Functions
    
    private func presentLocationServicesDisabledAlertView() {
        let title = "Turn on Location Services to Allow \"Scholars\" to Determine Your Location"
        self.presentResolveAuthorizationAlertView(with: title)
    }
    
    private func presentAuthorizationRestrictedAlertView() {
        let title = "Adjust Device Restrictions to Allow \"Scholars\" to Determine Your Location"
        self.presentResolveAuthorizationAlertView(with: title)
    }
    
    private func presentAuthorizationDeniedAlertView() {
        let title = "Allow \"Scholars\" to Use Location Services to Determine Your Location"
        self.presentResolveAuthorizationAlertView(with: title)
    }
    
    private func presentResolveAuthorizationAlertView(with title: String) {
        let message = "Your current location will be displayed on the map alongside Scholarship Winners from around the world."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        self.viewController.present(alertController, animated: true)
    }
}
