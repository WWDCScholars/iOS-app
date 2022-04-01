//
//  ProfileSubmissionsViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

import SwiftUI

// MARK: - Routing

extension ProfileSubmissionsView {
    struct Routing: Equatable {
        var selectedYear: String?
    }
}

// MARK: - ViewModel

extension ProfileSubmissionsView {
    final class ViewModel: ObservableObject {
        // State
        @Published var routingState: Routing
        let scholar: Scholar

        lazy var yearPickerViewModel = ProfileSubmissionsYearPickerView.ViewModel(container: container, scholar: scholar, selectedYear: .init(get: { self.routingState.selectedYear }, set: { self.routingState.selectedYear = $0 }))

        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()

        init(container: DIContainer, scholar: Scholar) {
            self.container = container
            self.scholar = scholar
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.scholarProfileSubmissions)
            cancelBag.collect {
                $routingState
                    .sink { appState[\.routing.scholarProfileSubmissions] = $0; }
                appState.map(\.routing.scholarProfileSubmissions)
                    .removeDuplicates()
                    .assign(to: \.routingState, on: self)
            }
        }
    }
}
