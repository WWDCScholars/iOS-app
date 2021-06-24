//
//  ServicesContainer.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

extension DIContainer {
    struct Services {
        let scholarsService: ScholarsService
        let yearsService: YearsService
        let aboutService: AboutService
        let imagesService: ImagesService
        let geocodingService: GeocodingService

        init(
            scholarsService: ScholarsService,
            yearsService: YearsService,
            aboutService: AboutService,
            imagesService: ImagesService,
            geocodingService: GeocodingService
        ) {
            self.scholarsService = scholarsService
            self.yearsService = yearsService
            self.aboutService = aboutService
            self.imagesService = imagesService
            self.geocodingService = geocodingService
        }

        static var stub: Self {
            .init(
                scholarsService: StubScholarsService(),
                yearsService: StubYearsService(),
                aboutService: StubAboutService(),
                imagesService: StubImagesService(),
                geocodingService: StubGeocodingService()
            )
        }
    }
}
