//
//  ScholarProfileViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 17.06.21.
//

import CoreLocation
import SwiftUI

extension ScholarProfileView {
    final class ViewModel: ObservableObject {
        // State
        @Published var scholar: Loadable<Scholar>
        @Published private var locationPlacemark: Loadable<CLPlacemark>
        private let scholarRecordName: String

        // Misc
        let container: DIContainer
        private let cancelBag = CancelBag()

        init(
            container: DIContainer,
            scholar: Loadable<Scholar> = .notRequested,
            locationPlacemark: Loadable<CLPlacemark> = .notRequested,
            scholarRecordName: String
        ) {
            self.container = container
            _scholar = .init(initialValue: scholar)
            _locationPlacemark = .init(initialValue: locationPlacemark)
            self.scholarRecordName = scholarRecordName
            cancelBag.collect {
                $scholar
                    .compactMap { loadable -> Scholar? in
                        guard case let .loaded(scholar) = loadable else { return nil }
                        return scholar
                    }
                    .map(\.location)
                    .sink(receiveValue: reverseGeocode(location:))
            }
        }

        // MARK: Side Effects

        func loadScholar() {
            container.services.scholarsService
                .load(
                    scholar: loadableSubject(\.scholar),
                    recordName: scholarRecordName
                )
        }

        private func reverseGeocode(location: CLLocation) {
            container.services.geocodingService
                .reverseGeocode(
                    placemark: loadableSubject(\.locationPlacemark),
                    of: location
                )
        }

        var readableLocation: String {
            switch locationPlacemark {
            case .notRequested: return "..."
            case .isLoading(_, _): return "..."
            case let .loaded(placemark):
                var slugComponents: [String] = []
                if let locality = placemark.locality {
                    slugComponents.append(locality)
                }
                if let administrativeArea = placemark.administrativeArea {
                    slugComponents.append(administrativeArea)
                }
                if let country = placemark.country {
                    slugComponents.append(country)
                } else if let countryCode = placemark.isoCountryCode {
                    slugComponents.append(countryCode)
                }
                return slugComponents.joined(separator: ", ")
            case let .failed(error): return "Failed: \(error.localizedDescription)"
            }
        }
    }
}
