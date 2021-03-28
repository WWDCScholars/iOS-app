//
//  DependencyInjector.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

// MARK: - DIContainer

struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let services: Services

    static var defaultValue: Self { Self.default }

    private static let `default` = Self(appState: AppState(), services: .stub)

    init(appState: Store<AppState>, services: Services) {
        self.appState = appState
        self.services = services
    }

    init(appState: AppState, services: Services) {
        self.init(appState: Store<AppState>(appState), services: services)
    }
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(appState: .preview, services: .stub)
    }
}
#endif
