//
//  AppState.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
    var permissions = Permissions()
}

extension AppState {
    struct UserData: Equatable {
        // Add global state, maybe scholars should live here
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var scholars = ScholarsView.Routing()
        var scholarsList = ScholarsListView.Routing()
    }
}

extension AppState {
    struct System: Equatable {
        // Add system state, e.g. current keyboardHeight
    }
}

extension AppState {
    struct Permissions: Equatable {
        // Add permissio state, e.g. location permission
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        return AppState()
    }
}
#endif
