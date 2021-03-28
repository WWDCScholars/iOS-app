//
//  WWDCScholarsApp.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

@main
struct WWDCScholarsApp: App {
    @Environment(\.scenePhase) var scenePhase

    let environment = AppEnvironment.bootstrap()
    var systemEventsHandler: SystemEventsHandler {
        return environment.systemEventsHandler
    }

    var body: some Scene {
        WindowGroup {
            StatusBarStyleView {
                ContentView(viewModel: .init(container: environment.container))
            }
            .onOpenURL(perform: systemEventsHandler.sceneOpenURL(_:))
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                self.systemEventsHandler.sceneDidBecomeActive()
            case .inactive:
                self.systemEventsHandler.sceneWillResignActive()
            default:
                break
            }
        }
    }
}
