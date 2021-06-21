//
//  GeocodingService.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 17.06.21.
//

import CoreLocation

protocol GeocodingService {
    func reverseGeocode(placemark: LoadableSubject<CLPlacemark>, of location: CLLocation)
}

struct GeocodingServiceImpl: GeocodingService {
    private let queue: DispatchQueue

    init(queue: DispatchQueue) {
        self.queue = queue
    }

    func reverseGeocode(placemark: LoadableSubject<CLPlacemark>, of location: CLLocation) {
        let cancelBag = CancelBag()
        placemark.wrappedValue.setIsLoading(cancelBag: cancelBag)

        CLGeocoder.reverseGeocodeLocationPublisher(for: location, on: queue)
            .tryMap { placemarks -> CLPlacemark in
                guard let placemark = placemarks.first else {
                    throw CLError(.geocodeFoundNoResult)
                }
                return placemark
            }
            .receive(on: RunLoop.main)
            .sinkToLoadable { placemark.wrappedValue = $0 }
            .store(in: cancelBag)
    }
}

struct StubGeocodingService: GeocodingService {
    func reverseGeocode(placemark: LoadableSubject<CLPlacemark>, of location: CLLocation) {}
}
