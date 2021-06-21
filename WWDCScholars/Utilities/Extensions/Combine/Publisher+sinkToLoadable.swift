//
//  Publisher+SinkToLoadable.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Combine

extension Publisher {
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { subscriptionCompletion in
            if case let .failure(error) = subscriptionCompletion {
                completion(.failed(error))
            }
        }, receiveValue: { value in
            completion(.loaded(value))
        })
    }

    func sinkToLoadableLoading(cancelBag: CancelBag, _ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { subscriptionCompletion in
            if case let .failure(error) = subscriptionCompletion {
                completion(.failed(error))
            }
        }, receiveValue: { value in
            completion(.isLoading(last: value, cancelBag: cancelBag))
        })
    }
}
