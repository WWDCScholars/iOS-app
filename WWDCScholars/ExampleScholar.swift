//
//  ExampleScholar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
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
    var socialMedia: SocialMedia { get }
}

internal struct SocialMedia {
    
    // MARK: - Internal Functions
    
    internal var iMessage: String?
    internal var iTunes: String?
    internal var website: String?
    internal var linkedIn: String?
    internal var gitHub: String?
    internal var facebook: String?
    internal var twitter: String?
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
    internal var socialMedia = SocialMedia()
    
    // MARK: - Lifecycle
    
    internal init() {
        self.socialMedia.iMessage = "andreww500@live.com"
        self.socialMedia.iTunes = ""
        self.socialMedia.website = "http://andrewnwalker.com"
        self.socialMedia.linkedIn = "https://www.linkedin.com/in/andrewneilwalker/"
        self.socialMedia.gitHub = "https://github.com/Andrew-Walker"
        self.socialMedia.facebook = "https://facebook.com/andrew.walker.5437"
        self.socialMedia.twitter = "https://twitter.com/AndrewNWalker"
    }
}

internal final class ScholarTwo: ExampleScholar {
    
    // MARK: - Internal Properties
    
    internal let firstName = "Andrew"
    internal let lastName = "Walker"
    internal let profileImage = UIImage(named: "profile")!
    internal let location = CLLocationCoordinate2D(latitude: 55.930247, longitude: -3.102059)
    internal let locationName = "Edinburgh, UK"
    internal let socialMedia = SocialMedia()
}

internal final class ScholarThree: ExampleScholar {
    
    // MARK: - Internal Properties
    
    internal let firstName = "Andrew"
    internal let lastName = "Walker"
    internal let profileImage = UIImage(named: "profile")!
    internal let location = CLLocationCoordinate2D(latitude: 55.908508, longitude: -3.224969)
    internal let locationName = "Edinburgh, UK"
    internal let socialMedia = SocialMedia()
}
