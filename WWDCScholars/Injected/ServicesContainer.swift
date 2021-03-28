//
//  ServicesContainer.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

extension DIContainer {
    struct Services {
        let yearsService: YearsService

        init(
            yearsService: YearsService
        ) {
            self.yearsService = yearsService
        }

        static var stub: Self {
            .init(
                yearsService: StubYearsService()
            )
        }
    }
}
