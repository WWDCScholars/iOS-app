//
//  ScholarSocialMedia.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 11.06.21.
//

import CloudKit

struct ScholarSocialMedia {
    let recordName: String

    let discord: String?
    let facebook: String?
    let github: String?
    let imessage: String?
    let instagram: String?
    let itunes: String?
    let linkedin: String?
    let twitter: String?
    let website: String?

    let scholar: CKRecord.Reference
}

extension ScholarSocialMedia: CKRecordConvertible {
    static let recordType = "ScholarSocialMedia"

    init?(record: CKRecord) {
        guard let scholar = record["scholar"] as? CKRecord.Reference
        else { return nil }

        recordName = record.recordID.recordName

        discord = record["discord"] as? String
        facebook = record["facebook"] as? String
        github = record["github"] as? String
        imessage = record["imessage"] as? String
        instagram = record["instagram"] as? String
        itunes = record["itunes"] as? String
        linkedin = record["linkedin"] as? String
        twitter = record["twitter"] as? String
        website = record["website"] as? String

        self.scholar = scholar
    }
}
