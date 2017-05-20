//
//  ExampleScholar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

internal protocol ExampleScholar {
    var firstName: String { get }
    var lastName: String { get }
    var profileImage: UIImage { get }
    var location: CLLocationCoordinate2D { get }
    var locationName: String { get }
}

internal extension ExampleScholar {
    
    // MARK: - Internal Functions
    
    internal var fullName: String {
        get {
            return self.firstName + " " + self.lastName
        }
    }
}

internal final class ScholarOne: ExampleScholar {
    
    // MARK: - Internal Properties
    
    internal let firstName = "Andrew"
    internal let lastName = "Walker"
    internal let profileImage = UIImage(named: "profile")!
    internal let location = CLLocationCoordinate2D(latitude: 55.959470, longitude: -3.260674)
    internal let locationName = "Edinburgh, UK"
}

internal final class ScholarTwo: ExampleScholar {
    
    // MARK: - Internal Properties
    
    internal let firstName = "Andrew"
    internal let lastName = "Walker"
    internal let profileImage = UIImage(named: "profile")!
    internal let location = CLLocationCoordinate2D(latitude: 55.930247, longitude: -3.102059)
    internal let locationName = "Edinburgh, UK"
}

internal final class ScholarThree: ExampleScholar {
    
    // MARK: - Internal Properties
    
    internal let firstName = "Andrew"
    internal let lastName = "Walker"
    internal let profileImage = UIImage(named: "profile")!
    internal let location = CLLocationCoordinate2D(latitude: 55.908508, longitude: -3.224969)
    internal let locationName = "Edinburgh, UK"
}
