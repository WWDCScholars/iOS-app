//
//  ScholarsListViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

// MARK: - Routing

extension ScholarsListView {
    struct Routing: Equatable {
        var scholarProfile: String?
    }
}

// MARK: - ViewModel

extension ScholarsListView {
    final class ViewModel: ObservableObject {
        // State
        @Published var routingState: Routing
        @Published var scholars: Loadable<LazyList<Scholar>>
        private let selectedYear: String?

        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()

        init(container: DIContainer, scholars: Loadable<LazyList<Scholar>> = .notRequested, selectedYear: String?) {
            self.container = container
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.scholarsList)
            _scholars = .init(initialValue: scholars)
            self.selectedYear = selectedYear
            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.scholarsList] = $0 }
                appState.map(\.routing.scholarsList)
                    .removeDuplicates()
                    .assign(to: \.routingState, on: self)
            }

            reloadScholars()
        }

        // MARK: Side Effects

        func reloadScholars() {
            guard let year = selectedYear else { return }

            container.services.scholarsService
                .load(
                    scholars: loadableSubject(\.scholars),
                    year: year
                )
        }
    }
}
