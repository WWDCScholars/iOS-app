//
//  YearsDatabaseRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import Combine

protocol YearsDatabaseRepository {
    func store(year: WWDCYear) -> AnyPublisher<WWDCYear?, Error>
    func year(recordName: String) -> AnyPublisher<WWDCYear?, Error>

    func hasLoadedYears() -> AnyPublisher<Bool, Error>

    func store(years: [WWDCYear]) -> AnyPublisher<Void, Error>
    func years() -> AnyPublisher<LazyList<WWDCYear>, Error>
}

struct YearsDatabaseRepositoryImpl: YearsDatabaseRepository {
    private let inMemoryStore = InMemoryStore()

    func store(year: WWDCYear) -> AnyPublisher<WWDCYear?, Error> {
        inMemoryStore.years[year.recordName] = year
        return Just.withErrorType(year, Error.self)
    }

    func year(recordName: String) -> AnyPublisher<WWDCYear?, Error> {
        return Just.withErrorType(Error.self)
            .map {
                inMemoryStore.years[recordName]
            }
            .eraseToAnyPublisher()
    }

    func hasLoadedYears() -> AnyPublisher<Bool, Error> {
        return Just.withErrorType(!inMemoryStore.years.isEmpty, Error.self)
    }

    func store(years: [WWDCYear]) -> AnyPublisher<Void, Error> {
        for year in years {
            inMemoryStore.years[year.recordName] = year
        }
        return Just.withErrorType(Error.self)
    }

    func years() -> AnyPublisher<LazyList<WWDCYear>, Error> {
        return Just.withErrorType(Error.self)
            .map { Array(inMemoryStore.years.values) }
            .map { $0.lazyList }
            .eraseToAnyPublisher()
    }
}

extension YearsDatabaseRepositoryImpl {
    private final class InMemoryStore {
        var years: [String: WWDCYear] = [:]
    }
}
