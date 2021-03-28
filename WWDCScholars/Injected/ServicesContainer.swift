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

        init(
            scholarsService: ScholarsService,
            yearsService: YearsService
        ) {
            self.scholarsService = scholarsService
            self.yearsService = yearsService
        }

        static var stub: Self {
            .init(
                scholarsService: StubScholarsService(),
                yearsService: StubYearsService()
            )
        }
    }
}
