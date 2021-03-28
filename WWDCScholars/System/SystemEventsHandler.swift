//
//  SystemEventsHandler.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Combine
import Foundation

protocol SystemEventsHandler {
    func sceneOpenURL(_ url: URL)
    func sceneDidBecomeActive()
    func sceneWillResignActive()
}

struct SystemEventsHandlerImpl: SystemEventsHandler {
    let container: DIContainer
    let deepLinkHandler: DeepLinkHandler
    private var cancelBag = CancelBag()

    init(
        container: DIContainer,
        deepLinkHandler: DeepLinkHandler
    ) {
        self.container = container
        self.deepLinkHandler = deepLinkHandler
    }

    func sceneOpenURL(_ url: URL) {
        guard let deepLink = DeepLink(url: url) else { return }
        deepLinkHandler.open(deepLink: deepLink)
    }

    func sceneDidBecomeActive() {}

    func sceneWillResignActive() {}
}
