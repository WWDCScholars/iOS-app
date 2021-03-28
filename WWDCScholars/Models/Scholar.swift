//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit

struct Scholar {
    let recordName: String

    let givenName: String
    let familyName: String
    let gender: String
    let birthday: Date
    let location: CLLocation
    let biography: String
    let profilePicture: CKAsset
    let gdprConsentAt: Date

    let scholarPrivate: CKRecord.Reference
    let socialMedia: CKRecord.Reference
    let wwdcYearInfos: [CKRecord.Reference]
    let wwdcYears: [CKRecord.Reference]
    let wwdcYearsApproved: [CKRecord.Reference]
}

extension Scholar: Identifiable {
    var id: String { recordName }
}

extension Scholar: Equatable {}

extension Scholar: Comparable {
    static func < (lhs: Scholar, rhs: Scholar) -> Bool {
        return lhs.givenName < rhs.givenName
    }
}

extension Scholar: CKRecordConvertible {
    static var recordType: String { "Scholar" }

    init?(record: CKRecord) {
        guard let givenName = record["givenName"] as? String,
              let familyName = record["familyName"] as? String,
              let gender = record["gender"] as? String,
              let birthday = record["birthday"] as? Date,
              let location = record["location"] as? CLLocation,
              let biography = record["biography"] as? String,
              let profilePicture = record["profilePicture"] as? CKAsset,
              let gdprConsentAt = record["gdprConsentAt"] as? Date,
              let scholarPrivate = record["scholarPrivate"] as? CKRecord.Reference,
              let socialMedia = record["socialMedia"] as? CKRecord.Reference,
              let wwdcYearInfos = record["wwdcYearInfos"] as? [CKRecord.Reference],
              let wwdcYears = record["wwdcYears"] as? [CKRecord.Reference],
              let wwdcYearsApproved = record["wwdcYearsApproved"] as? [CKRecord.Reference]
        else { return nil }

        recordName = record.recordID.recordName

        self.givenName = givenName
        self.familyName = familyName
        self.gender = gender
        self.birthday = birthday
        self.location = location
        self.biography = biography
        self.profilePicture = profilePicture
        self.gdprConsentAt = gdprConsentAt

        self.scholarPrivate = scholarPrivate
        self.socialMedia = socialMedia
        self.wwdcYearInfos = wwdcYearInfos
        self.wwdcYears = wwdcYears
        self.wwdcYearsApproved = wwdcYearsApproved
    }
}

// MARK: - Convenience

extension Scholar {
    var fullName: String {
        "\(givenName) \(familyName)"
    }
}
