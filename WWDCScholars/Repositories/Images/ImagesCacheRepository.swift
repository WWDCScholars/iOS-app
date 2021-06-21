//
//  ImagesCacheRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import Combine
import UIKit

protocol ImagesCacheRepository {
    typealias ImageCacheKey = String

    func cache(image: UIImage, key: ImageCacheKey)
    func cachedImage(for key: ImageCacheKey) -> AnyPublisher<UIImage, ImageCacheError>
    func purgeCache(for key: ImageCacheKey)
    func purgeCache()
}
