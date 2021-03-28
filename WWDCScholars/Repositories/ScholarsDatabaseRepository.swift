//
//  ScholarsDatabaseRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Combine

protocol ScholarsDatabaseRepository {
    func hasLoadedScholars(year: String) -> AnyPublisher<Bool, Error>

    func store(scholars: [Scholar]) -> AnyPublisher<Void, Error>
    func scholars(year: String) -> AnyPublisher<LazyList<Scholar>, Error>
}

struct ScholarsDatabaseRepositoryImpl: ScholarsDatabaseRepository {
    private let inMemoryStore = InMemoryStore()

    func hasLoadedScholars(year: String) -> AnyPublisher<Bool, Error> {
        let scholars = inMemoryStore.scholars.values.filter { $0.wwdcYearsApproved.map(\.recordID.recordName).contains(year) }
        return Just.withErrorType(!scholars.isEmpty, Error.self)
    }

    func store(scholars: [Scholar]) -> AnyPublisher<Void, Error> {
        for scholar in scholars {
            inMemoryStore.scholars[scholar.recordName] = scholar
        }
        return Just.withErrorType(Error.self)
    }

    func scholars(year: String) -> AnyPublisher<LazyList<Scholar>, Error> {
        return Just.withErrorType(Error.self)
            .map {
                inMemoryStore.scholars.values
                    .filter { $0.wwdcYearsApproved.map(\.recordID.recordName).contains(year) }
            }
            .map { $0.lazyList }
            .eraseToAnyPublisher()
    }
}

extension ScholarsDatabaseRepositoryImpl {
    private final class InMemoryStore {
        var scholars: [String: Scholar] = [:]
    }
}
