//
//  WWDCYearInfo.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 26.03.22.
//

import CloudKit
import UIKit

struct WWDCYearInfo {
    let recordName: String

    let acceptanceEmail: UIImage?
    let appliedAs: String
    let description: String
    let status: String
    let screenshots: [UIImage]
    let githubLink: String?
    let videoLink: String?
    let appstoreLink: String?
    let appType: String

    let reviewedAt: Date?
    let reviewedBy: CKRecord.Reference?

    let scholar: CKRecord.Reference
    let year: CKRecord.Reference
}

extension WWDCYearInfo: CKRecordConvertible {
    init?(record: CKRecord) {
        guard let appliedAs = record["appliedAs"] as? String,
              let description = record["description"] as? String,
              let status = record["status"] as? String,
              let appType = record["appType"] as? String,
              let scholar = record["scholar"] as? CKRecord.Reference,
              let year = record["year"] as? CKRecord.Reference
        else { return nil }

        recordName = record.recordID.recordName

        acceptanceEmail = (record["acceptanceEmail"] as? CKAsset)?.image
        self.appliedAs = appliedAs
        self.description = description
        self.status = status
        self.screenshots = (record["screenshots"] as? [CKAsset])?.compactMap(\.image) ?? []
        githubLink = record["githubLink"] as? String
        videoLink = record["videoLink"] as? String
        appstoreLink = record["appstoreLink"] as? String
        self.appType = appType

        reviewedAt = record["reviewedAt"] as? Date
        reviewedBy = record["reviewedBy"] as? CKRecord.Reference

        self.scholar = scholar
        self.year = year
    }
}

// MARK: Partial Fetching

extension WWDCYearInfo {
    enum DesiredKeys {
        static let `default`: [CKRecord.FieldKey] = [
            "appliedAs",
            "description",
            "status",
            "screenshots",
            "githubLink",
            "videoLink",
            "appstoreLinks",
            "appType",
            "scholar",
            "year"
        ]

        static let onlyAcceptanceEmail: [CKRecord.FieldKey] = ["acceptanceEmail"]
    }
}
