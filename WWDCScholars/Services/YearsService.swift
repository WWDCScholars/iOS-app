//
//  YearsService.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import Combine
import Foundation

protocol YearsService {
    func refreshYearsList() -> AnyPublisher<Void, Error>
    func load(years: LoadableSubject<LazyList<WWDCYear>>)
}

struct YearsServiceImpl: YearsService {
    let cloudKitRepository: YearsCloudKitRepository
    let databaseRepository: YearsDatabaseRepository
    let appState: Store<AppState>

    init(
        cloudKitRepository: YearsCloudKitRepository,
        databaseRepository: YearsDatabaseRepository,
        appState: Store<AppState>
    ) {
        self.cloudKitRepository = cloudKitRepository
        self.databaseRepository = databaseRepository
        self.appState = appState
    }

    func refreshYearsList() -> AnyPublisher<Void, Error> {
        return cloudKitRepository
            .loadAllYears()
            .flatMap { [databaseRepository] in
                databaseRepository.store(years: $0)
            }
            .eraseToAnyPublisher()
    }

    func load(years: LoadableSubject<LazyList<WWDCYear>>) {
        let cancelBag = CancelBag()
        years.wrappedValue.setIsLoading(cancelBag: cancelBag)

        Just.withErrorType(Error.self)
            .flatMap { [databaseRepository] in
                databaseRepository.hasLoadedYears()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just.withErrorType(Error.self)
                } else {
                    return self.refreshYearsList()
                }
            }
            .flatMap { [databaseRepository] in
                databaseRepository.years()
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { years.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

#if DEBUG
struct StubYearsService: YearsService {
    func refreshYearsList() -> AnyPublisher<Void, Error> {
        return Just.withErrorType(Error.self)
    }

    func load(years: LoadableSubject<LazyList<WWDCYear>>) {
        years.wrappedValue = .loaded(WWDCYear.mockData.lazyList)
    }
}
#endif
