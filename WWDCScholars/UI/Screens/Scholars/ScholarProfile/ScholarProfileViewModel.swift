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

        var socialsViewModel: ProfileSocialsView.ViewModel?
        var submissionsViewModel: ProfileSubmissionsView.ViewModel?

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
                    .compactMap(\.value)
                    .sink(receiveValue: onScholarLoaded(_:))
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

        private func onScholarLoaded(_ scholar: Scholar) {
            socialsViewModel = .init(container: container, scholar: scholar)
            submissionsViewModel = .init(container: container, scholar: scholar)

            reverseGeocode(location: scholar.location)
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

        func loadProfilePicture(_ image: LoadableSubject<UIImage>, of scholar: Scholar) -> CancelBag {
            container.services.imagesService.loadProfilePicture(image, of: scholar)
        }
    }
}
