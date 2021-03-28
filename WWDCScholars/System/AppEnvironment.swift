//
//  AppEnvironment.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())

        let services = configuredServices(appState: appState)
        let diContainer = DIContainer(appState: appState, services: services)

        let deepLinkHandler = DeepLinkHandlerImpl(container: diContainer)
        let systemEventsHandler = SystemEventsHandlerImpl(
            container: diContainer,
            deepLinkHandler: deepLinkHandler
        )

        return AppEnvironment(container: diContainer, systemEventsHandler: systemEventsHandler)
    }

    private static func configuredServices(appState: Store<AppState>) -> DIContainer.Services {
        return .init()
    }
}
