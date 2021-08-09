//
//  ImagesService.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import CloudKit
import Combine
import UIKit

protocol ImagesService {
    func loadProfilePicture(_ image: LoadableSubject<UIImage>, of scholar: Scholar) -> CancelBag
    func loadPicture(_ image: LoadableSubject<UIImage>, of teamMember: TeamMember) -> CancelBag
}

struct ImagesServiceImpl: ImagesService {
    private let scholarsCloudKitRepository: ScholarsCloudKitRepositry
    private let aboutCloudKitRepository: AboutCloudKitRepository
    private let memoryCacheRepository: ImagesCacheRepository

    init(
        scholarsCloudKitRepository: ScholarsCloudKitRepositry,
        aboutCloudKitRepository: AboutCloudKitRepository,
        memoryCacheRepository: ImagesCacheRepository
    ) {
        self.scholarsCloudKitRepository = scholarsCloudKitRepository
        self.aboutCloudKitRepository = aboutCloudKitRepository
        self.memoryCacheRepository = memoryCacheRepository
        // TODO: Memory Warning
    }

    func loadProfilePicture(_ image: LoadableSubject<UIImage>, of scholar: Scholar) -> CancelBag {
        let cancelBag = CancelBag()
        image.wrappedValue.setIsLoading(cancelBag: cancelBag)

        // maybe add changetag
        let cacheKey = "\(scholar.recordName)_profilePicture"

        memoryCacheRepository.cachedImage(for: cacheKey)
//            .catch { _ in
//                  // TODO: Filesystem Cache
//            }
            .catch { _ -> AnyPublisher<UIImage, Error> in
                if let profilePicture = scholar.profilePicture {
                    return Just(profilePicture).setFailureType(to: Error.self).eraseToAnyPublisher()
                }

                return self.scholarsCloudKitRepository.loadScholarProfilePicture(of: scholar)
                    .flatMap { asset -> AnyPublisher<UIImage, Error> in
                        if let fetchedImage = asset.image {
                            return Just(fetchedImage).setFailureType(to: Error.self).eraseToAnyPublisher()
                        }
                        return Fail(error: ImagesServiceError.fetchedImageMissing).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable {
                if let image = $0.value {
                    self.memoryCacheRepository.cache(image: image, key: cacheKey)
                }
                image.wrappedValue = $0
            }
            .store(in: cancelBag)

        return cancelBag
    }

    func loadPicture(_ image: LoadableSubject<UIImage>, of teamMember: TeamMember) -> CancelBag {
        let cancelBag = CancelBag()
        image.wrappedValue.setIsLoading(cancelBag: cancelBag)

        // maybe add changetag
        let cacheKey = "\(teamMember.recordName)_picture"

        memoryCacheRepository.cachedImage(for: cacheKey)
//            .catch { _ in
//                  // TODO: Filesystem Cache
//            }
            .catch { _ -> AnyPublisher<UIImage, Error> in
                if let picture = teamMember.picture {
                    return Just(picture).setFailureType(to: Error.self).eraseToAnyPublisher()
                }

                return self.aboutCloudKitRepository.loadTeamMemberPicture(of: teamMember)
                    .flatMap { asset -> AnyPublisher<UIImage, Error> in
                        if let fetchedImage = asset.image {
                            return Just(fetchedImage).setFailureType(to: Error.self).eraseToAnyPublisher()
                        }
                        return Fail(error: ImagesServiceError.fetchedImageMissing).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable {
                if let image = $0.value {
                    self.memoryCacheRepository.cache(image: image, key: cacheKey)
                }
                image.wrappedValue = $0
            }
            .store(in: cancelBag)

        return cancelBag
    }
}

enum ImagesServiceError: Error {
    case fetchedImageMissing
}

struct StubImagesService: ImagesService {
    func loadProfilePicture(_ image: LoadableSubject<UIImage>, of scholar: Scholar) -> CancelBag {
        if let profilePicture = scholar.profilePicture {
            image.wrappedValue = .loaded(profilePicture)
        } else {
            image.wrappedValue = .failed(ValueIsMissingError())
        }

        return CancelBag()
    }

    func loadPicture(_ image: LoadableSubject<UIImage>, of teamMember: TeamMember) -> CancelBag {
        if let picture = teamMember.picture {
            image.wrappedValue = .loaded(picture)
        } else {
            image.wrappedValue = .failed(ValueIsMissingError())
        }

        return CancelBag()
    }
}
