//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import CoreLocation

internal class Scholar {
    var id: UUID?
	
    var firstName: String
    var lastName: String
    var gender: Gender
    var birthday: Date
    var location: CLLocation
    
    var email: String
    var shortBio: String
    
    var socialMediaId: UUID

    var yearInfo: [WWDCYear : UUID]
    
    var status : Status
    
    var approvedOn: Date?
    var createdAt: Date?
    
    internal var profilePictureURL: URL?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init?(record: [String: Any]) {
        guard
            let id           = record["id"] as? UUID,
            let creationDate = record["creationDate"] as? Date,
            let location     = record["location"] as? CLLocation,
            let shortBio     = record["shortBio"] as? String,
            let gender       = record["gender"] as? Gender,
            let birthday     = record["birthday"] as? Date,
            let email        = record["email"] as? String,
            let firstName    = record["firstName"] as? String,
            let lastName     = record["lastName"] as? String,
            let socialMedia  = record["socialMedia"] as? UUID,
            let yearInfo     = record["yearInfo"] as? [WWDCYear : UUID],
            let status       = record["status"] as? Status,
            let approvedOn   = record["approvedOn"] as? Date else {
                assertionFailure("Scholar initializer - Initialized without all data")
                return nil
        }
        
        self.id = id
        
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        self.location = location
        
        self.email = email
        self.socialMediaId = socialMedia
        
        self.shortBio = shortBio
        
        self.yearInfo = yearInfo
        
        self.status = status
        
        self.createdAt = creationDate
        self.approvedOn = approvedOn
    }
}
