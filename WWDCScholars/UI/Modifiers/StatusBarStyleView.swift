//
//  StatusBarStyleView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 28.03.21.
//

import SwiftUI

struct StatusBarStyleView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        EmptyView()
            .onAppear {
                UIApplication.shared.setHostingController(rootView: AnyView(content))
            }
    }
}

extension View {
    /// Set the status bar style for this view.
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        UIApplication.statusBarStyleHierarchy.append(style)

        return onAppear {
            UIApplication.setStatusBarStyle(style)
        }.onDisappear {
            guard let style = UIApplication.statusBarStyleHierarchy.popLast() else { return }
            UIApplication.setStatusBarStyle(style)
        }
    }
}

// MARK: -

final class StatusBarStyleHostingController<Content: View>: UIHostingController<Content> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        UIApplication.statusBarStyle
    }
}

extension UIApplication {
    static var hostingController: StatusBarStyleHostingController<AnyView>?

    static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
    static var statusBarStyle: UIStatusBarStyle = .default

    func setHostingController(rootView: AnyView) {
        let hostingController = StatusBarStyleHostingController(rootView: rootView)
        windows.first?.rootViewController = hostingController
        UIApplication.hostingController = hostingController
    }

    static func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        hostingController?.setNeedsStatusBarAppearanceUpdate()
    }
}
