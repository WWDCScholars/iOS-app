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

    func store(socialMedia: ScholarSocialMedia, for scholar: Scholar) -> AnyPublisher<ScholarSocialMedia?, Error>
    func socialMedia(for scholar: Scholar) -> AnyPublisher<ScholarSocialMedia?, Error>
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

    func store(socialMedia: ScholarSocialMedia, for scholar: Scholar) -> AnyPublisher<ScholarSocialMedia?, Error> {
        inMemoryStore.socialMedias[socialMedia.recordName] = socialMedia
        return Just.withErrorType(socialMedia, Error.self)
    }

    func socialMedia(for scholar: Scholar) -> AnyPublisher<ScholarSocialMedia?, Error> {
        return Just.withErrorType(inMemoryStore.socialMedias[scholar.socialMedia.recordID.recordName], Error.self)
    }
}

extension ScholarsDatabaseRepositoryImpl {
    private final class InMemoryStore {
        var scholars: [String: Scholar] = [:]
        var socialMedias: [String: ScholarSocialMedia] = [:]
    }
}
