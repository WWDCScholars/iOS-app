//
//  Location.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

class Location {
    let name: String!
    let longitude: Double!
    let latitude: Double!
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    //todo? Switch to reverse geocoding using CoreLocation
}
