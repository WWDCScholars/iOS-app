//
//  TeamMember.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import CloudKit

struct TeamMember {
    let recordName: String

    let name: String
    let biography: String?
    let birthday: Date?
    let picture: CKAsset?
    let isActive: Bool
    let scholar: CKRecord.Reference?
}

extension TeamMember: Identifiable {
    var id: String { recordName }
}

extension TeamMember: Equatable {}

extension TeamMember: Comparable {
    static func < (lhs: TeamMember, rhs: TeamMember) -> Bool {
        return lhs.name < rhs.name
    }
}

extension TeamMember: CKRecordConvertible {
    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let isActiveNumber = record["isActive"] as? NSNumber,
              let isActive = Bool(exactly: isActiveNumber)
        else { return nil }

        recordName = record.recordID.recordName

        self.name = name
        biography = record["biography"] as? String
        birthday = record["birthday"] as? Date
        picture = record["picture"] as? CKAsset
        self.isActive = isActive
        scholar = record["scholar"] as? CKRecord.Reference
    }
}

// MARK: - Partial Fetching

extension TeamMember {
    enum DesiredKeys {
        static let `default`: [CKRecord.FieldKey] = [
            "name",
            "biography",
            "birthday",
            "isActive",
            "scholar"
        ]

        static let onlyPicture: [CKRecord.FieldKey] = ["picture"]
    }
}
