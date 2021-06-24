//
//  AboutDatabaseRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import Combine

protocol AboutDatabaseRepository {
    func hasLoadedTeamMembers(isActive: Bool) -> AnyPublisher<Bool, Error>
    func store(teamMembers: [TeamMember]) -> AnyPublisher<Void, Error>
    func teamMembers(isActive: Bool) -> AnyPublisher<LazyList<TeamMember>, Error>

    func hasLoadedFAQItems() -> AnyPublisher<Bool, Error>
    func store(faqItems: [FAQItem]) -> AnyPublisher<Void, Error>
    func faqItems() -> AnyPublisher<LazyList<FAQItem>, Error>
}

struct AboutDatabaseRepositoryImpl: AboutDatabaseRepository {
    private let inMemoryStore = InMemoryStore()

    func hasLoadedTeamMembers(isActive: Bool) -> AnyPublisher<Bool, Error> {
        let teamMembers = inMemoryStore.teamMembers.values.filter { $0.isActive == isActive }
        return Just.withErrorType(!teamMembers.isEmpty, Error.self)
    }

    func store(teamMembers: [TeamMember]) -> AnyPublisher<Void, Error> {
        for teamMember in teamMembers {
            inMemoryStore.teamMembers[teamMember.recordName] = teamMember
        }
        return Just.withErrorType(Error.self)
    }

    func teamMembers(isActive: Bool) -> AnyPublisher<LazyList<TeamMember>, Error> {
        return Just.withErrorType(Error.self)
            .map {
                inMemoryStore.teamMembers.values
                    .filter { $0.isActive == isActive }
                    .sorted()
            }
            .map { $0.lazyList }
            .eraseToAnyPublisher()
    }

    func hasLoadedFAQItems() -> AnyPublisher<Bool, Error> {
        return Just.withErrorType(!inMemoryStore.faqItems.values.isEmpty, Error.self)
    }

    func store(faqItems: [FAQItem]) -> AnyPublisher<Void, Error> {
        for faqItem in faqItems {
            inMemoryStore.faqItems[faqItem.recordName] = faqItem
        }
        return Just.withErrorType(Error.self)
    }

    func faqItems() -> AnyPublisher<LazyList<FAQItem>, Error> {
        return Just.withErrorType(Error.self)
            .map { Array(inMemoryStore.faqItems.values) }
            .map { $0.lazyList }
            .eraseToAnyPublisher()
    }
}

extension AboutDatabaseRepositoryImpl {
    private final class InMemoryStore {
        var teamMembers: [String: TeamMember] = [:]
        var faqItems: [String: FAQItem] = [:]
    }
}
