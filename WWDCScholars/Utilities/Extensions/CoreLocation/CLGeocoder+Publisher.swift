//
//  CLGeocoder+Publisher.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 17.06.21.
//

import Combine
import CoreLocation

extension CLGeocoder {
    class func reverseGeocodeLocationPublisher(
        for location: CLLocation,
        preferredLocale: Locale? = nil,
        on queue: DispatchQueue
    ) -> CLGeocoder.ReverseGeocodePublisher {
        return CLGeocoder.ReverseGeocodePublisher(
            for: location,
            preferredLocale: preferredLocale,
            on: queue
        )
    }
}

extension CLGeocoder {
    /// A publisher that wraps `CLGeocoder.reverseGeocodeLocation()`.
    struct ReverseGeocodePublisher: Publisher {
        // MARK: Properties

        /// The location to reverse-geocode.
        private let location: CLLocation

        /// The locale to use when returning the address information.
        private let preferredLocale: Locale?

        /// The queue to run the operation on.
        private let queue: DispatchQueue

        // MARK: Initialization

        /// Creates a new `CLGeocoder.ReverseGeocodePublisher`.
        ///
        /// - Parameters:
        ///     - location: The location to reverse-geocode.
        ///     - preferredLocale: The locale to use when returning the address information.
        ///     - queue: The queue to run the operation on.
        init(
            for location: CLLocation,
            preferredLocale: Locale? = nil,
            on queue: DispatchQueue
        ) {
            self.location = location
            self.preferredLocale = preferredLocale
            self.queue = queue
        }

        // MARK: Publisher Implementation

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(
                subscriber: subscriber,
                for: location,
                preferredLocale: preferredLocale,
                on: queue
            )
            subscriber.receive(subscription: subscription)
        }

        typealias Output = [CLPlacemark]
        typealias Failure = Error
    }
}

// MARK: - Subscription

extension CLGeocoder.ReverseGeocodePublisher {
    ///
    final class Subscription<S: Subscriber> where S.Input == Output, S.Failure == Failure {
        // MARK: Properties

        /// The subscriber to notify for events.
        private var subscriber: S?

        /// The location to reverse-geocode.
        private let location: CLLocation

        /// The locale to use when returning the address information.
        private let preferredLocale: Locale?

        /// The queue to run the operation on.
        private let queue: DispatchQueue

        /// The geocoder object while in flight.
        private var geocoder: CLGeocoder?

        // MARK: Initialization

        init(
            subscriber: S,
            for location: CLLocation,
            preferredLocale: Locale?,
            on queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.location = location
            self.preferredLocale = preferredLocale
            self.queue = queue
        }

        // MARK: Operation

        /// Runs the operation and handles the results.
        private func runOperation() {
            let geocoder = CLGeocoder()
            self.geocoder = geocoder

            geocoder.reverseGeocodeLocation(location, preferredLocale: preferredLocale) { [weak self] placemarks, error in
                if let error = error as? CLError {
                    self?.handleError(error)
                } else if let error = error {
                    self?.subscriber?.receive(completion: .failure(error))
                } else {
                    _ = self?.subscriber?.receive(placemarks ?? [])
                }
            }
        }

        /// Handle CoreLocation errors.
        ///
        /// - Parameter error: The error to handle
        private func handleError(_ error: CLError) {
            if error.code == CLError.geocodeCanceled {
                subscriber?.receive(completion: .finished)
            } else {
                subscriber?.receive(completion: .failure(error))
            }
        }
    }
}

// MARK: -

extension CLGeocoder.ReverseGeocodePublisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
        geocoder?.cancelGeocode()
    }
}

extension CLGeocoder.ReverseGeocodePublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        guard demand != .none,
              subscriber != nil
        else { return }

        queue.async {
            self.runOperation()
        }
    }
}
