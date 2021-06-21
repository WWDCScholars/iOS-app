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
}

struct ImagesServiceImpl: ImagesService {
    private let scholarsCloudKitRepository: ScholarsCloudKitRepositry
    private let memoryCacheRepository: ImagesCacheRepository

    init(
        scholarsCloudKitRepository: ScholarsCloudKitRepositry,
        memoryCacheRepository: ImagesCacheRepository
    ) {
        self.scholarsCloudKitRepository = scholarsCloudKitRepository
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
                if let asset = scholar.profilePicture, let loadedImage = loadAsset(asset) {
                    return Just(loadedImage).setFailureType(to: Error.self).eraseToAnyPublisher()
                }

                return self.scholarsCloudKitRepository.loadScholarProfilePicture(of: scholar)
                    .flatMap { asset -> AnyPublisher<UIImage, Error> in
                        if let fetchedImage = loadAsset(asset) {
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

    private func loadAsset(_ asset: CKAsset) -> UIImage? {
        guard let imageURL = asset.fileURL else { return nil }
        return UIImage(contentsOfFile: imageURL.path)
    }
}

enum ImagesServiceError: Error {
    case fetchedImageMissing
}

struct StubImagesService: ImagesService {
    func loadProfilePicture(_ image: LoadableSubject<UIImage>, of scholar: Scholar) -> CancelBag {
        fatalError()
    }
}
