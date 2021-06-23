//
//  Scholar+MockData.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import CoreLocation
import Foundation

#if DEBUG
extension Scholar {
    static let mockData: [Scholar] = [
        .init(
            recordName: "4B12EC83-9A0A-44F2-A815-D4A99AA7D208",
            givenName: "Moritz",
            familyName: "Sternemann",
            gender: "male",
            birthday: Date(),
            location: CLLocation(latitude: 37.335351, longitude: -122.009730),
            biography: "Moritz is the most recent addition to our team and mostly worked on our website and the signup form. He attended WWDC as a scholarship winner for three years.",
            profilePicture: nil,
            gdprConsentAt: Date(),
            scholarPrivate: CKRecord.Reference(recordID: .init(recordName: "0C8D2624-38CE-483F-90D5-12A328D6B177"), action: .none),
            socialMedia: CKRecord.Reference(recordID: .init(recordName: "D9A2B77D-8279-4E40-8906-318F74605990"), action: .none),
            wwdcYearInfos: [],
            wwdcYears: [],
            wwdcYearsApproved: []
        ),
        .init(
            recordName: "AA1EE7F8-C2A1-459D-85DD-F65EBD362E2C",
            givenName: "Sam",
            familyName: "Eckert",
            gender: "male",
            birthday: Date(),
            location: CLLocation(latitude: 34.011286, longitude: -116.166969),
            biography: "Sam started developing iOS apps when he turned 14. He received two WWDC scholarships and is now connecting companies with the young generation at agenZy.",
            profilePicture: nil,
            gdprConsentAt: Date(),
            scholarPrivate: CKRecord.Reference(recordID: .init(recordName: "0C8D2624-38CE-483F-90D5-12A328D6B177"), action: .none),
            socialMedia: CKRecord.Reference(recordID: .init(recordName: "D9A2B77D-8279-4E40-8906-318F74605990"), action: .none),
            wwdcYearInfos: [],
            wwdcYears: [],
            wwdcYearsApproved: []
        ),
        .init(
            recordName: "98F70329-666D-40E9-95A5-63A359935400",
            givenName: "Michie",
            familyName: "Ang",
            gender: "female",
            birthday: Date(),
            location: CLLocation(latitude: 34.011286, longitude: -116.166969),
            biography: "Michie was a nurse when she first got into iOS development. She won a scholarship three times, builds tech communities and travels around to inspire others to learn programming.",
            profilePicture: nil,
            gdprConsentAt: Date(),
            scholarPrivate: CKRecord.Reference(recordID: .init(recordName: "0C8D2624-38CE-483F-90D5-12A328D6B177"), action: .none),
            socialMedia: CKRecord.Reference(recordID: .init(recordName: "D9A2B77D-8279-4E40-8906-318F74605990"), action: .none),
            wwdcYearInfos: [],
            wwdcYears: [],
            wwdcYearsApproved: []
        )
    ]
}
#endif
