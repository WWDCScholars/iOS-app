//
//  WWDCYear.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.03.21.
//

import CloudKit

struct WWDCYear {
    let recordName: String

    let name: String
    let year: String
    let challengeDescription: String?
}

extension WWDCYear: Identifiable {
    var id: String { recordName }
}

extension WWDCYear: Equatable {}

extension WWDCYear: Comparable {
    static func < (lhs: WWDCYear, rhs: WWDCYear) -> Bool {
        return lhs.year < rhs.year
    }
}

extension WWDCYear: CKRecordConvertible {
    static var recordType: String { "WWDCYear" }

    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
              let year = record["year"] as? String
        else { return nil }

        recordName = record.recordID.recordName
        self.name = name
        self.year = year
        challengeDescription = record["challengeDescription"] as? String
    }
}
