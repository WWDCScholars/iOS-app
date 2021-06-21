//
//  ScholarsCloudKitRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import Combine

protocol ScholarsCloudKitRepositry: CloudKitRepository {
    func loadAllScholars(year: String) -> AnyPublisher<[Scholar], Error>
}

struct ScholarsCloudKitRepositoryImpl: ScholarsCloudKitRepositry {
    let database: CKDatabase
    let queue: DispatchQueue

    init(in database: CKDatabase, on queue: DispatchQueue) {
        self.database = database
        self.queue = queue
    }

    func loadAllScholars(year: String) -> AnyPublisher<[Scholar], Error> {
        let yearRecordID = CKRecord.ID(recordName: year)
        let referenceDate = Date()
        let predicate = NSPredicate(format: "wwdcYearsApproved CONTAINS %@ AND gdprConsentAt <= %@", argumentArray: [yearRecordID, referenceDate])
        let sortGivenName = NSSortDescriptor(key: "givenName", ascending: true)
        let sortFamilyName = NSSortDescriptor(key: "familyName", ascending: true)
        let scholarsQuery = CKQuery(recordType: Scholar.recordType, predicate: predicate)
        scholarsQuery.sortDescriptors = [sortGivenName, sortFamilyName]

        return query(scholarsQuery)
    }
}