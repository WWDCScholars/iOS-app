//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import MapKit
import CloudKit

/**
 Model which represents a scholar in the app
 */
internal struct Scholar {
    var id: CKRecord.ID?
    var createdAt: Date?
    
    var biography: String?
    var birthday: Date?
    var email: String?
    var familyName: String?
    var gdprConsentAt: Date?
    var gender: Gender?
    var givenName: String?
    var loc: CLLocation?
    var profilePicture: CKAsset?
    var scholarPrivate: CKRecord.Reference?
    var socialMedia: CKRecord.Reference?
    var wwdcYearInfos: [CKRecord.Reference]?
    var wwdcYears: [CKRecord.Reference]?
    var wwdcYearsApproved: [CKRecord.Reference]?

    /** Convenience variable to return the full name of the scholar */
    var fullName: String {
        return "\(givenName) \(familyName)"
    }
}

extension Scholar {
        /// Constructor to get an instance of a scholar using a dictionary with data
        ///
        /// - Parameter record: A dictionary containing the information of the scholar
    init?(scholarRecord: CKRecord) {
        id = scholarRecord.recordID
        createdAt = scholarRecord.creationDate
        
        biography = scholarRecord["biography"] as? String
        birthday = scholarRecord["birthday"] as? Date
        email = scholarRecord["email"] as? String
        familyName = scholarRecord["familyName"] as? String
        gdprConsentAt = scholarRecord["gdprConsentAt"] as? Date
        gender = Gender(rawValue: scholarRecord["gender"] as? String ?? "other")!
        givenName = scholarRecord["givenName"] as? String
        loc = scholarRecord["location"] as? CLLocation
        profilePicture = scholarRecord["profilePicture"] as? CKAsset
        socialMedia = scholarRecord["socialMedia"] as? CKRecord.Reference
        wwdcYearInfos = scholarRecord["wwdcYearInfos"] as? [CKRecord.Reference]
        wwdcYears = (scholarRecord["wwdcYears"] as? [CKRecord.Reference])?.sorted(by: { $0.recordID.recordName < $1.recordID.recordName })
        wwdcYearsApproved = scholarRecord["wwdcYearsApproved"] as? [CKRecord.Reference]
    }
}
