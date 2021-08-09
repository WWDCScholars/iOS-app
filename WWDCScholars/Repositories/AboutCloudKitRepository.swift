//
//  AboutCloudKitRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import CloudKit
import Combine
import OSLog

protocol AboutCloudKitRepository: CloudKitRepository {
    func loadAllTeamMembers(isActive: Bool) -> AnyPublisher<[TeamMember], Error>
    func loadTeamMemberPicture(of teamMember: TeamMember) -> AnyPublisher<CKAsset, Error>
    func loadAllFAQItems(languageCode: String) -> AnyPublisher<[FAQItem], Error>
}

struct AboutCloudKitRepositoryImpl: AboutCloudKitRepository {
    private let logger = Logger(subsystem: Logger.subsystem("AboutCloudKitRepository"), category: .cloudKit)

    let database: CKDatabase
    let queue: DispatchQueue

    init(in database: CKDatabase, on queue: DispatchQueue) {
        self.database = database
        self.queue = queue
    }

    func loadAllTeamMembers(isActive: Bool) -> AnyPublisher<[TeamMember], Error> {
        let predicated = NSPredicate(format: "isActive == %@", NSNumber(value: isActive))
        let teamMembersQuery = CKQuery(recordType: TeamMember.recordType, predicate: predicated)
        teamMembersQuery.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        logger.info("loadAllTeamMembers isActive=\(isActive, privacy: .public)")
        return queryAll(teamMembersQuery, desiredKeys: TeamMember.DesiredKeys.default)
    }

    func loadTeamMemberPicture(of teamMember: TeamMember) -> AnyPublisher<CKAsset, Error> {
        let teamMemberRecordID = CKRecord.ID(recordName: teamMember.recordName)

        logger.info("loadTeamMemberPicture teamMember=\(teamMember.recordName)")
        return fetch(recordID: teamMemberRecordID, desiredKeys: TeamMember.DesiredKeys.onlyPicture)
            .compactMap { record -> CKAsset? in
                return record["picture"] as? CKAsset
            }
            .eraseToAnyPublisher()
    }

    func loadAllFAQItems(languageCode: String) -> AnyPublisher<[FAQItem], Error> {
        let faqItemsQuery = CKQuery(recordType: FAQItem.recordType, predicate: NSPredicate(value: true))
        faqItemsQuery.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]

        logger.info("loadAllFAQItems languageCode=\(languageCode, privacy: .public)")
        return queryAll(faqItemsQuery, desiredKeys: FAQItem.DesiredKeys.default(for: languageCode))
    }
}
