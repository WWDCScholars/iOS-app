//
//  AppEnvironment.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import Foundation

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())

        let database = configuredCloudKitDatabase()
        let cloudKitRepositories = configuredCloudKitRepositories(database: database)
        let databaseRepositories = configureDatabaseRepositories(appState: appState)
        let services = configuredServices(
            appState: appState,
            databaseRepositories: databaseRepositories,
            cloudKitRepositories: cloudKitRepositories
        )
        let diContainer = DIContainer(appState: appState, services: services)

        let deepLinkHandler = DeepLinkHandlerImpl(container: diContainer)
        let systemEventsHandler = SystemEventsHandlerImpl(
            container: diContainer,
            deepLinkHandler: deepLinkHandler
        )

        return AppEnvironment(container: diContainer, systemEventsHandler: systemEventsHandler)
    }

    private static func configuredCloudKitDatabase() -> CKDatabase {
        let container = CKContainer(identifier: "iCloud.com.cecose.WWDCScholars")
        return container.publicCloudDatabase
    }

    private static func configuredCloudKitRepositories(database: CKDatabase) -> DIContainer.CloudKitRepositories {
        let queue = DispatchQueue(label: "CloudKit", qos: .userInitiated)

        let yearsCloudKitRepository = YearsCloudKitRepositoryImpl(
            database: database,
            queue: queue
        )

        return .init(
            yearsRepository: yearsCloudKitRepository
        )
    }

    private static func configureDatabaseRepositories(appState: Store<AppState>) -> DIContainer.DatabaseRepositories {
        let yearsDatabaseRepository = YearsDatabaseRepositoryImpl()

        return .init(
            yearsRepository: yearsDatabaseRepository
        )
    }

    private static func configuredServices(
        appState: Store<AppState>,
        databaseRepositories: DIContainer.DatabaseRepositories,
        cloudKitRepositories: DIContainer.CloudKitRepositories
    ) -> DIContainer.Services {
        let yearsService = YearsServiceImpl(
            cloudKitRepository: cloudKitRepositories.yearsRepository,
            databaseRepository: databaseRepositories.yearsRepository,
            appState: appState
        )

        return .init(
            yearsService: yearsService
        )
    }
}

extension DIContainer {
    struct CloudKitRepositories {
        let yearsRepository: YearsCloudKitRepository
    }

    struct DatabaseRepositories {
        let yearsRepository: YearsDatabaseRepository
    }
}
