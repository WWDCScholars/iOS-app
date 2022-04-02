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
    func load(yearInfoAndYear: LoadableSubject<(WWDCYearInfo, WWDCYear)>, scholar: Scholar, yearRecordName: String)
}

struct ScholarsServiceImpl: ScholarsService {
    let scholarsCloudKitRepository: ScholarsCloudKitRepositry
    let scholarsDatabaseRepository: ScholarsDatabaseRepository
    let yearsCloudKitRepository: YearsCloudKitRepository
    let yearsDatabaseRepository: YearsDatabaseRepository
    let appState: Store<AppState>

    init(
        scholarsCloudKitRepository: ScholarsCloudKitRepositry,
        scholarsDatabaseRepository: ScholarsDatabaseRepository,
        yearsCloudKitRepository: YearsCloudKitRepository,
        yearsDatabaseRepository: YearsDatabaseRepository,
        appState: Store<AppState>
    ) {
        self.scholarsCloudKitRepository = scholarsCloudKitRepository
        self.scholarsDatabaseRepository = scholarsDatabaseRepository
        self.yearsCloudKitRepository = yearsCloudKitRepository
        self.yearsDatabaseRepository = yearsDatabaseRepository
        self.appState = appState
    }

    private func loadScholar(recordName: String) -> AnyPublisher<Void, Error> {
        return scholarsCloudKitRepository
            .loadScholar(recordName: recordName)
            .flatMap { [scholarsDatabaseRepository] in
                scholarsDatabaseRepository.store(scholar: $0)
            }
            .eraseToAnyPublisher()
    }

    func load(scholar: LoadableSubject<Scholar>, recordName: String) {
        let cancelBag = CancelBag()
        scholar.wrappedValue.setIsLoading(cancelBag: cancelBag)

        Just.withErrorType(Error.self)
            .flatMap { [scholarsDatabaseRepository] () -> AnyPublisher<Scholar?, Error> in
                scholarsDatabaseRepository.scholar(recordName: recordName)
            }
            .flatMap { [scholarsDatabaseRepository] scholar -> AnyPublisher<Scholar?, Error> in
                if let scholar = scholar {
                    return Just.withErrorType(scholar, Error.self)
                } else {
                    return loadScholar(recordName: recordName)
                        .flatMap { [scholarsDatabaseRepository] in
                            scholarsDatabaseRepository.scholar(recordName: recordName)
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
        return scholarsCloudKitRepository
            .loadAllScholars(year: year)
            .flatMap { [scholarsDatabaseRepository] in
                scholarsDatabaseRepository.store(scholars: $0)
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
        scholarsDatabaseRepository.scholars(year: year)
            .receive(on: RunLoop.main)
            .sinkToLoadableLoading(cancelBag: cancelBag) { scholars.wrappedValue = $0 }
            .store(in: cancelBag)

        // start loading all Scholars from CloudKit
        refreshScholarsList(year: year)
            .flatMap { [scholarsDatabaseRepository] in
                scholarsDatabaseRepository.scholars(year: year)
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { scholars.wrappedValue = $0 }
            .store(in: cancelBag)
    }

    func load(socialMedia: LoadableSubject<ScholarSocialMedia>, scholar: Scholar) {
        let cancelBag = CancelBag()
        socialMedia.wrappedValue.setIsLoading(cancelBag: cancelBag)

        scholarsDatabaseRepository
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
        return scholarsCloudKitRepository
            .loadSocialMedia(with: scholar.socialMedia.recordID)
            .flatMap { [scholarsDatabaseRepository] in
                scholarsDatabaseRepository.store(socialMedia: $0, for: scholar)
            }
            .eraseToAnyPublisher()
    }

    func load(yearInfoAndYear: LoadableSubject<(WWDCYearInfo, WWDCYear)>, scholar: Scholar, yearRecordName: String) {
        let cancelBag = CancelBag()
        yearInfoAndYear.wrappedValue.setIsLoading(cancelBag: cancelBag)

        // Use wwdcYears instead of wwdcYears approved to get the correct index
        guard let yearInfoIndex = scholar.wwdcYears.firstIndex(where: { $0.recordID.recordName == yearRecordName }),
              let yearInfoRecordName = scholar.wwdcYearInfos[safe: yearInfoIndex]?.recordID.recordName
        else {
            // TODO: Maybe we want a more specific error and display an error message
            yearInfoAndYear.wrappedValue = .failed(ValueIsMissingError())
            return
        }

        let yearInfoPublisher = scholarsDatabaseRepository
            .yearInfo(for: scholar, yearInfoRecordName: yearInfoRecordName)
            .flatMap { yearInfo -> AnyPublisher<WWDCYearInfo?, Error> in
                if yearInfo != nil {
                    return Just.withErrorType(yearInfo, Error.self)
                } else {
                    return self.loadAndStoreYearInfoFromCloudKit(scholar: scholar, yearInfoRecordName: yearInfoRecordName)
                }
            }

        let yearPublisher = yearsDatabaseRepository
            .year(recordName: yearRecordName)
            .flatMap { year -> AnyPublisher<WWDCYear?, Error> in
                if year != nil {
                    return Just.withErrorType(year, Error.self)
                } else {
                    return self.loadAndStoreYearFromCloudKit(recordName: yearRecordName)
                }
            }

        yearInfoPublisher
            .zip(yearPublisher)
            .receive(on: RunLoop.main)
            .map { yearInfo, year -> (WWDCYearInfo, WWDCYear)? in
                guard let yearInfo = yearInfo,
                      let year = year
                else { return nil }
                return (yearInfo, year)
            }
            .sinkToLoadable { yearInfoAndYear.wrappedValue = $0.unwrap() }
            .store(in: cancelBag)
    }

    private func loadAndStoreYearInfoFromCloudKit(scholar: Scholar, yearInfoRecordName: String) -> AnyPublisher<WWDCYearInfo?, Error> {
        return scholarsCloudKitRepository
            .loadWWDCYearInfo(with: .init(recordName: yearInfoRecordName))
            .flatMap { [scholarsDatabaseRepository] in
                scholarsDatabaseRepository.store(yearInfo: $0, for: scholar)
            }
            .eraseToAnyPublisher()
    }

    private func loadAndStoreYearFromCloudKit(recordName: String) -> AnyPublisher<WWDCYear?, Error> {
        return yearsCloudKitRepository
            .loadYear(recordName: recordName)
            .flatMap { [yearsDatabaseRepository] in
                yearsDatabaseRepository.store(year: $0)
            }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct StubScholarsService: ScholarsService {
    func load(scholar: LoadableSubject<Scholar>, recordName: String) {
        scholar.wrappedValue = .loaded(Scholar.mockData[0])
    }

    func refreshScholarsList(year: String) -> AnyPublisher<Void, Error> {
        return Just.withErrorType(Error.self)
    }

    func load(scholars: LoadableSubject<LazyList<Scholar>>, year: String) {
        scholars.wrappedValue = .loaded(Scholar.mockData.lazyList)
    }

    func load(socialMedia: LoadableSubject<ScholarSocialMedia>, scholar: Scholar) {
        socialMedia.wrappedValue = .loaded(ScholarSocialMedia.mockData[0])
    }

    func load(yearInfoAndYear: LoadableSubject<(WWDCYearInfo, WWDCYear)>, scholar: Scholar, yearRecordName: String) {
        yearInfoAndYear.wrappedValue = .loaded((
            WWDCYearInfo.mockData[0],
            WWDCYear.mockData.last!
        ))
    }
}
#endif
