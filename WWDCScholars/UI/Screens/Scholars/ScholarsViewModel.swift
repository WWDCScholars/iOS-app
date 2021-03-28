//
//  ScholarsViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 25.03.21.
//

import SwiftUI

// MARK: - Routing

extension ScholarsView {
    struct Routing: Equatable {
        var selectedYear: String?
    }
}

// MARK: - ViewModel

extension ScholarsView {
    final class ViewModel: ObservableObject {
        // State
        @Published var routingState: Routing

        lazy var yearPickerViewModel = YearPickerView.ViewModel(container: container, selectedYear: .init(get: { self.routingState.selectedYear }, set: { self.routingState.selectedYear = $0 }))

        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()

        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.scholars)
            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.scholars] = $0 }
                appState.map(\.routing.scholars)
                    .removeDuplicates()
                    .assign(to: \.routingState, on: self)
            }
        }
    }
}
