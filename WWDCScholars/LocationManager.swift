//
//  LocationManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LocationManager {
    static let sharedInstance = LocationManager()
    
    func getLocationDetails(_ coordinates: CLLocationCoordinate2D, completion: @escaping (_ locality: String, _ country: String) -> Void) {
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
