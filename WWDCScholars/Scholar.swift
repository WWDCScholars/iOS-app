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
    
    var approvedOn: Date?
    var createdAt: Date?
    var status : Status
    
    internal var profilePictureURL: URL?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(record: [String: Any]) {
        id = record["id"] as? UUID
        createdAt = record["creationDate"] as? Date
        
        location = record["location"] as! CLLocation
        shortBio = record["shortBio"] as! String
        gender = Gender(rawValue: record["gender"] as! String)!
        birthday = record["birthday"] as! Date
        email = record["email"] as! String
        lastName = record["lastName"] as! String
        firstName = record["firstName"] as! String
        
        socialMediaId = record["socialMedia"] as! UUID
        yearInfo = record["yearInfo"] as! [WWDCYear : UUID]

        status = Status(rawValue: record["status"] as! String)!
        approvedOn = record["approvedOn"] as? Date
    }
}
