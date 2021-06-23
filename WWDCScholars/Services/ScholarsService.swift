//
//  ScholarsService.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Combine
import Foundation

protocol ScholarsService {
    func load(scholar: LoadableSubject<Scholar>, recordName: String)
    func refreshScholarsList(year: String) -> AnyPublisher<Void, Error>
    func load(scholars: LoadableSubject<LazyList<Scholar>>, year: String)
    func load(socialMedia: LoadableSubject<ScholarSocialMedia>, scholar: Scholar)
}

struct ScholarsServiceImpl: ScholarsService {
    let cloudKitRepository: ScholarsCloudKitRepositry
    let databaseRepository: ScholarsDatabaseRepository
    let appState: Store<AppState>

    init(
        cloudKitRepository: ScholarsCloudKitRepositry,
        databaseRepository: ScholarsDatabaseRepository,
        appState: Store<AppState>
    ) {
        self.cloudKitRepository = cloudKitRepository
        self.databaseRepository = databaseRepository
        self.appState = appState
    }

    private func loadScholar(recordName: String) -> AnyPublisher<Void, Error> {
        return cloudKitRepository
            .loadScholar(recordName: recordName)
            .flatMap { [databaseRepository] in
                databaseRepository.store(scholar: $0)
            }
            .eraseToAnyPublisher()
    }

    func load(scholar: LoadableSubject<Scholar>, recordName: String) {
        let cancelBag = CancelBag()
        scholar.wrappedValue.setIsLoading(cancelBag: cancelBag)

        Just.withErrorType(Error.self)
            .flatMap { [databaseRepository] () -> AnyPublisher<Scholar?, Error> in
                databaseRepository.scholar(recordName: recordName)
            }
            .flatMap { [databaseRepository] scholar -> AnyPublisher<Scholar?, Error> in
                if let scholar = scholar {
                    return Just.withErrorType(scholar, Error.self)
                } else {
                    return loadScholar(recordName: recordName)
                        .flatMap { [databaseRepository] in
                            databaseRepository.scholar(recordName: recordName)
                        }
                        .eraseToAnyPublisher()
                }
            }
            .tryMap { scholar -> Scholar in
                guard let scholar = scholar else {
                    throw NotFoundError()
                }
                return scholar
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { scholar.wrappedValue = $0 }
            .store(in: cancelBag)
    }

    func refreshScholarsList(year: String) -> AnyPublisher<Void, Error> {
        return cloudKitRepository
            .loadAllScholars(year: year)
            .flatMap { [databaseRepository] in
                databaseRepository.store(scholars: $0)
            }
            .eraseToAnyPublisher()
    }

    func load(scholars: LoadableSubject<LazyList<Scholar>>, year: String) {
        let cancelBag = CancelBag()
        scholars.wrappedValue.setIsLoading(cancelBag: cancelBag)

        // Scholars loading behavior
        // 1. return all Scholars from cache
        // 2. start loading all Scholars from CloudKit
        //   2.1 when done, replace loaded with new result

        // return all Scholars from cache
        databaseRepository.scholars(year: year)
            .receive(on: RunLoop.main)
            .sinkToLoadableLoading(cancelBag: cancelBag) { scholars.wrappedValue = $0 }
            .store(in: cancelBag)

        // start loading all Scholars from CloudKit
        refreshScholarsList(year: year)
            .flatMap { [databaseRepository] in
                databaseRepository.scholars(year: year)
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { scholars.wrappedValue = $0 }
            .store(in: cancelBag)
    }

    func load(socialMedia: LoadableSubject<ScholarSocialMedia>, scholar: Scholar) {
        let cancelBag = CancelBag()
        socialMedia.wrappedValue.setIsLoading(cancelBag: cancelBag)

        databaseRepository
            .socialMedia(for: scholar)
            .flatMap { socialMedia -> AnyPublisher<ScholarSocialMedia?, Error> in
                if socialMedia != nil {
                    return Just(socialMedia).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return self.loadAndStoreSocialMediaFromCloudKit(scholar: scholar)
                }
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { socialMedia.wrappedValue = $0.unwrap() }
            .store(in: cancelBag)
    }

    private func loadAndStoreSocialMediaFromCloudKit(scholar: Scholar) -> AnyPublisher<ScholarSocialMedia?, Error> {
        return cloudKitRepository
            .loadSocialMedia(with: scholar.socialMedia.recordID)
            .flatMap { [databaseRepository] in
                databaseRepository.store(socialMedia: $0, for: scholar)
            }
            .eraseToAnyPublisher()
    }
}

struct StubScholarsService: ScholarsService {
    func load(scholar: LoadableSubject<Scholar>, recordName: String) {
        scholar.wrappedValue = .loaded(Scholar.mockData[0])
    }

    func refreshScholarsList(year: String) -> AnyPublisher<Void, Error> {
        return Just.withErrorType(Error.self)
    }

    func load(scholars: LoadableSubject<LazyList<Scholar>>, year: String) {}

    func load(socialMedia: LoadableSubject<ScholarSocialMedia>, scholar: Scholar) {}
}
