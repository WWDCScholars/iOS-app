//
//  ScholarsCloudKitRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import Combine
import OSLog

protocol ScholarsCloudKitRepositry: CloudKitRepository {
    func loadScholar(recordName: String) -> AnyPublisher<Scholar, Error>
    func loadAllScholars(year: String) -> AnyPublisher<[Scholar], Error>
    func loadScholarProfilePicture(of scholar: Scholar) -> AnyPublisher<CKAsset, Error>
    func loadSocialMedia(with recordID: CKRecord.ID) -> AnyPublisher<ScholarSocialMedia, Error>
    func loadWWDCYearInfo(with recordID: CKRecord.ID) -> AnyPublisher<WWDCYearInfo, Error>
}

struct ScholarsCloudKitRepositoryImpl: ScholarsCloudKitRepositry {
    private let logger = Logger(subsystem: Logger.subsystem("ScholarsCloudKitRepository"), category: .cloudKit)

    let database: CKDatabase
    let queue: DispatchQueue

    init(in database: CKDatabase, on queue: DispatchQueue) {
        self.database = database
        self.queue = queue
    }

    func loadScholar(recordName: String) -> AnyPublisher<Scholar, Error> {
        let scholarRecordID = CKRecord.ID(recordName: recordName)

        logger.info("loadScholar: \(recordName)")
        return fetch(recordID: scholarRecordID)
    }

    func loadAllScholars(year: String) -> AnyPublisher<[Scholar], Error> {
        let yearRecordID = CKRecord.ID(recordName: year)
        let referenceDate = Date()
        let predicate = NSPredicate(format: "wwdcYearsApproved CONTAINS %@ AND gdprConsentAt < %@", argumentArray: [yearRecordID, referenceDate])
        let sortGivenName = NSSortDescriptor(key: "givenName", ascending: true)
        let sortFamilyName = NSSortDescriptor(key: "familyName", ascending: true)
        let scholarsQuery = CKQuery(recordType: Scholar.recordType, predicate: predicate)
        scholarsQuery.sortDescriptors = [sortGivenName, sortFamilyName]

        logger.info("loadAllScholars year=\(year, privacy: .public)")
        return queryAll(scholarsQuery, desiredKeys: Scholar.DesiredKeys.default)
    }

    func loadScholarProfilePicture(of scholar: Scholar) -> AnyPublisher<CKAsset, Error> {
        let scholarRecordID = CKRecord.ID(recordName: scholar.recordName)

        logger.info("loadScholarProfilePicture scholar=\(scholar.recordName)")
        return fetch(recordID: scholarRecordID, desiredKeys: Scholar.DesiredKeys.onlyProfilePicture)
            .compactMap { record -> CKAsset? in
                return record["profilePicture"] as? CKAsset
            }
            .eraseToAnyPublisher()
    }

    func loadSocialMedia(with recordID: CKRecord.ID) -> AnyPublisher<ScholarSocialMedia, Error> {
        logger.info("loadSocialMedia: \(recordID.recordName)")
        return fetch(recordID: recordID)
    }

    func loadWWDCYearInfo(with recordID: CKRecord.ID) -> AnyPublisher<WWDCYearInfo, Error> {
        logger.info("loadWWDCYearInfo: \(recordID.recordName)")
        return fetch(recordID: recordID, desiredKeys: WWDCYearInfo.DesiredKeys.default)
    }
}
