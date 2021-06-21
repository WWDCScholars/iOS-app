//
//  Store.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import Combine
import SwiftUI

typealias Store<State> = CurrentValueSubject<State, Never>

extension Store {
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }

    func bulkUpdate(_ update: (inout Output) -> Void) {
        var value = self.value
        update(&value)
        self.value = value
    }

    func updates<Value>(for keyPath: KeyPath<Output, Value>) -> AnyPublisher<Value, Failure> where Value: Equatable {
        return map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }
}

// MARK: -

extension ObservableObject {
    func loadableSubject<Value>(_ keyPath: WritableKeyPath<Self, Loadable<Value>>) -> LoadableSubject<Value> {
        let defaultValue = self[keyPath: keyPath]
        return .init(get: { [weak self] in
            self?[keyPath: keyPath] ?? defaultValue
        }, set: { [weak self] in
            self?[keyPath: keyPath] = $0
        })
    }
}

extension Binding where Value: Equatable {
    typealias ValueClosure = (Value) -> Void

    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: {
            self.wrappedValue
        }, set: { value in
            if self.wrappedValue != value {
                self.wrappedValue = value
            }
            perform(value)
        })
    }
}
