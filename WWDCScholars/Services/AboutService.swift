//
//  AboutService.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import Combine
import Foundation

protocol AboutService {
    func load(teamMembers: LoadableSubject<LazyList<TeamMember>>, isActive: Bool)
    func load(faqItems: LoadableSubject<LazyList<FAQItem>>)
}

struct AboutServiceImpl: AboutService {
    let cloudKitRepository: AboutCloudKitRepository
    let databaseRepository: AboutDatabaseRepository

    init(
        cloudKitRepository: AboutCloudKitRepository,
        databaseRepository: AboutDatabaseRepository
    ) {
        self.cloudKitRepository = cloudKitRepository
        self.databaseRepository = databaseRepository
    }

    func load(teamMembers: LoadableSubject<LazyList<TeamMember>>, isActive: Bool) {
        let cancelBag = CancelBag()
        teamMembers.wrappedValue.setIsLoading(cancelBag: cancelBag)

        // return all TeamMembers from cache
        databaseRepository.teamMembers(isActive: isActive)
            .receive(on: RunLoop.main)
            .sinkToLoadableLoading(cancelBag: cancelBag) { teamMembers.wrappedValue = $0 }
            .store(in: cancelBag)

        // start loading all TeamMembers from CloudKit
        loadAndStoreTeamMembers(isActive: isActive)
            .flatMap { [databaseRepository] in
                databaseRepository.teamMembers(isActive: isActive)
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { teamMembers.wrappedValue = $0 }
            .store(in: cancelBag)
    }

    private func loadAndStoreTeamMembers(isActive: Bool) -> AnyPublisher<Void, Error> {
        return cloudKitRepository
            .loadAllTeamMembers(isActive: isActive)
            .flatMap { [databaseRepository] in
                databaseRepository.store(teamMembers: $0)
            }
            .eraseToAnyPublisher()
    }

    func load(faqItems: LoadableSubject<LazyList<FAQItem>>) {
        let cancelBag = CancelBag()
        faqItems.wrappedValue.setIsLoading(cancelBag: cancelBag)

        // return all FAQItems from cache
        databaseRepository.faqItems()
            .receive(on: RunLoop.main)
            .sinkToLoadableLoading(cancelBag: cancelBag) { faqItems.wrappedValue = $0 }
            .store(in: cancelBag)

        // start loading all FAQItems from CloudKit
        loadAndStoreFAQItems(languageCode: "en")
            .flatMap { [databaseRepository] in
                databaseRepository.faqItems()
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { faqItems.wrappedValue = $0 }
            .store(in: cancelBag)
    }

    private func loadAndStoreFAQItems(languageCode: String) -> AnyPublisher<Void, Error> {
        return cloudKitRepository
            .loadAllFAQItems(languageCode: languageCode)
            .flatMap { [databaseRepository] in
                databaseRepository.store(faqItems: $0)
            }
            .eraseToAnyPublisher()
    }
}

struct StubAboutService: AboutService {
    func load(teamMembers: LoadableSubject<LazyList<TeamMember>>, isActive: Bool) {
        let members = TeamMember.mockData.filter { $0.isActive == isActive }
        teamMembers.wrappedValue = .loaded(members.lazyList)
    }

    func load(faqItems: LoadableSubject<LazyList<FAQItem>>) {
        faqItems.wrappedValue = .loaded(FAQItem.mockData.lazyList)
    }
}
