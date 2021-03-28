//
//  ScholarsService.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Combine
import Foundation

protocol ScholarsService {
    func refreshScholarsList(year: String) -> AnyPublisher<Void, Error>
    func load(scholars: LoadableSubject<LazyList<Scholar>>, year: String)
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

        Just.withErrorType(Error.self)
            .flatMap { [databaseRepository] in
                databaseRepository.hasLoadedScholars(year: year)
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    return self.refreshScholarsList(year: year)
                }
            }
            .flatMap { [databaseRepository] in
                databaseRepository.scholars(year: year)
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { scholars.wrappedValue = $0 }
            .store(in: cancelBag)

    }
}

struct StubScholarsService: ScholarsService {
    func refreshScholarsList(year: String) -> AnyPublisher<Void, Error> {
        return Just.withErrorType(Error.self)
    }

    func load(scholars: LoadableSubject<LazyList<Scholar>>, year: String) {}
}
