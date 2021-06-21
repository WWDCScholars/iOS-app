//
//  ImagesMemoryCacheRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import Combine
import UIKit

struct ImagesMemoryCacheRepositoryImpl: ImagesCacheRepository {
    private let cache = NSCache<NSString, UIImage>()

    func cache(image: UIImage, key: ImageCacheKey) {
        cache.setObject(image, forKey: key as NSString, cost: image.estimatedSizeInKB)
    }

    func cachedImage(for key: ImageCacheKey) -> AnyPublisher<UIImage, ImageCacheError> {
        guard let image = cache.object(forKey: key as NSString) else {
            return Fail(error: .imageIsMissing).eraseToAnyPublisher()
        }

        return Just(image)
            .setFailureType(to: ImageCacheError.self)
            .eraseToAnyPublisher()
    }

    func purgeCache(for key: ImageCacheKey) {
        cache.removeObject(forKey: key as NSString)
    }

    func purgeCache() {
        cache.removeAllObjects()
    }
}
