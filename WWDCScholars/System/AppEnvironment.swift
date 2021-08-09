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
        let cacheRepositories = configureCacheRepositories()
        let services = configuredServices(
            appState: appState,
            databaseRepositories: databaseRepositories,
            cloudKitRepositories: cloudKitRepositories,
            cacheRepositories: cacheRepositories
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

        let scholarsCloudKitRepository = ScholarsCloudKitRepositoryImpl(in: database, on: queue)
        let yearsCloudKitRepository = YearsCloudKitRepositoryImpl(database: database, queue: queue)
        let aboutCloudKitRepository = AboutCloudKitRepositoryImpl(in: database, on: queue)

        return .init(
            scholarsRepository: scholarsCloudKitRepository,
            yearsRepository: yearsCloudKitRepository,
            aboutRepository: aboutCloudKitRepository
        )
    }

    private static func configureDatabaseRepositories(appState: Store<AppState>) -> DIContainer.DatabaseRepositories {
        let scholarsDatabaseRepository = ScholarsDatabaseRepositoryImpl()
        let yearsDatabaseRepository = YearsDatabaseRepositoryImpl()
        let aboutDatabaseRepository = AboutDatabaseRepositoryImpl()

        return .init(
            scholarsRepository: scholarsDatabaseRepository,
            yearsRepository: yearsDatabaseRepository,
            aboutRepository: aboutDatabaseRepository
        )
    }

    private static func configureCacheRepositories() -> DIContainer.CacheRepositories {
        let imagesMemoryCacheRepository = ImagesMemoryCacheRepositoryImpl()

        return .init(imagesMemoryRepository: imagesMemoryCacheRepository)
    }

    private static func configuredGeocodingService() -> GeocodingService {
        let queue = DispatchQueue(label: "Geocoding", qos: .userInitiated)

        return GeocodingServiceImpl(queue: queue)
    }

    private static func configuredServices(
        appState: Store<AppState>,
        databaseRepositories: DIContainer.DatabaseRepositories,
        cloudKitRepositories: DIContainer.CloudKitRepositories,
        cacheRepositories: DIContainer.CacheRepositories
    ) -> DIContainer.Services {
        let scholarsService = ScholarsServiceImpl(
            cloudKitRepository: cloudKitRepositories.scholarsRepository,
            databaseRepository: databaseRepositories.scholarsRepository,
            appState: appState
        )
        let yearsService = YearsServiceImpl(
            cloudKitRepository: cloudKitRepositories.yearsRepository,
            databaseRepository: databaseRepositories.yearsRepository,
            appState: appState
        )
        let aboutService = AboutServiceImpl(
            cloudKitRepository: cloudKitRepositories.aboutRepository,
            databaseRepository: databaseRepositories.aboutRepository
        )
        let imagesService = ImagesServiceImpl(
            scholarsCloudKitRepository: cloudKitRepositories.scholarsRepository,
            aboutCloudKitRepository: cloudKitRepositories.aboutRepository,
            memoryCacheRepository: cacheRepositories.imagesMemoryRepository
        )
        let geocodingService = configuredGeocodingService()

        return .init(
            scholarsService: scholarsService,
            yearsService: yearsService,
            aboutService: aboutService,
            imagesService: imagesService,
            geocodingService: geocodingService
        )
    }
}

extension DIContainer {
    struct CloudKitRepositories {
        let scholarsRepository: ScholarsCloudKitRepositry
        let yearsRepository: YearsCloudKitRepository
        let aboutRepository: AboutCloudKitRepository
    }

    struct DatabaseRepositories {
        let scholarsRepository: ScholarsDatabaseRepository
        let yearsRepository: YearsDatabaseRepository
        let aboutRepository: AboutDatabaseRepository
    }

    struct CacheRepositories {
        let imagesMemoryRepository: ImagesCacheRepository
    }
}
