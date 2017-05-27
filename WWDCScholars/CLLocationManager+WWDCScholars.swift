//
//  CLLocationManager+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import CoreLocation

internal extension CLLocationManager {
    
    // MARK: - Internal Functions
    
    internal static func isAuthorized() -> Bool {
        let status = self.authorizationStatus()
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
}
