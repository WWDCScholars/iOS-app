//
//  DeepLinkHandler.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Foundation

enum DeepLink: Equatable {
    init?(url: URL) {
        return nil
    }
}

// MARK: - DeepLinkHandler

protocol DeepLinkHandler {
    func open(deepLink: DeepLink)
}

struct DeepLinkHandlerImpl: DeepLinkHandler {
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func open(deepLink: DeepLink) {

    }
}
