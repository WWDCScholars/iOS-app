//
//  NavigationBarColor.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.21.
//

import SwiftUI

struct NavigationBarColor: ViewModifier {
    let backgroundColor: UIColor

    init(backgroundColor: UIColor, tintColor: UIColor) {
        self.backgroundColor = backgroundColor

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.shadowImage = UIImage()
        coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                GeometryReader { geometry in
                    Color(backgroundColor)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        return modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }

    var purpleNavigationBar: some View {
        return navigationBarColor(backgroundColor: UIColor(.theme.brand), tintColor: UIColor(.theme.onBrand))
            .statusBarStyle(.lightContent)
    }
}
