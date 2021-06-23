//
//  YearsCloudKitRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.03.21.
//

import CloudKit
import Combine
import OSLog

protocol YearsCloudKitRepository: CloudKitRepository {
    func loadAllYears() -> AnyPublisher<[WWDCYear], Error>
}

struct YearsCloudKitRepositoryImpl: YearsCloudKitRepository {
    private let logger = Logger(subsystem: Logger.subsystem("YearsCloudKitRepository"), category: .cloudKit)

    let database: CKDatabase
    let queue: DispatchQueue

    func loadAllYears()  -> AnyPublisher<[WWDCYear], Error> {
        let sortYear = NSSortDescriptor(key: "year", ascending: true)
        let yearsQuery = CKQuery(recordType: WWDCYear.recordType, predicate: NSPredicate(value: true))
        yearsQuery.sortDescriptors = [sortYear]

        logger.info("loadAllYears")
        return queryAll(yearsQuery)
    }
}
