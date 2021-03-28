//
//  Just+WithErrorType.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import Combine

extension Just {
    static func withErrorType<E>(_ value: Output, _ errorType: E.Type) -> AnyPublisher<Output, E> {
        return Just(value)
            .setFailureType(to: errorType)
            .eraseToAnyPublisher()
    }
}

extension Just where Output == Void {
    static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
        return withErrorType((), errorType)
    }
}
