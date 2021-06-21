//
//  Colors.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 05.06.21.
//

import SwiftUI

struct BaseColor {
    // MARK: Dynamic Colors

    let brandPrimary = Color("brandPrimary")
    let brandSecondary = Color("brandSecondary")

    let contrastPrimary = Color("contrastPrimary")
    let contrastSecondary = Color("contrastSecondary")

    // MARK: Static Colors

    let purple = Color("purple")
    let white = Color("white")
}

struct ThemeColor {
    private let baseColor = BaseColor()

    let brand: Color

    let highlight: Color
    let secondaryHighlight: Color

    let primary: Color
    let secondary: Color

    let onBrand: Color

    init() {
        brand = baseColor.purple

        highlight = baseColor.brandPrimary
        secondaryHighlight = baseColor.brandSecondary

        primary = baseColor.contrastPrimary
        secondary = baseColor.contrastSecondary

        onBrand = baseColor.white
    }
}

extension Color {
    static let theme = ThemeColor()
}
