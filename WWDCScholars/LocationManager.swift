//
//  LocationManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

class LocationManager {
    static let sharedInstance = LocationManager()
    
    func getLocationDetails(coordinates: CLLocationCoordinate2D, completion: (locality: String, country: String) -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), completionHandler: {(placemarks, error) -> Void in
            if placemarks?.count > 0 {
                if let containsPlacemark = placemarks?.first {
                    let localityString = containsPlacemark.locality != nil ? containsPlacemark.locality! : "Unknown"
                    let countryString = containsPlacemark.country != nil ? containsPlacemark.country! : "Unknown"
                    
                    completion((locality: localityString, country: countryString))
                }
            }
        })
    }
}
