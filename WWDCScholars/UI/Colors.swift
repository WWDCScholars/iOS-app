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

    let primary = Color("primary")
    let secondary = Color("secondary")

    let contrastPrimary = Color("contrastPrimary")

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
    let onPrimary: Color

    init() {
        brand = baseColor.purple

        highlight = baseColor.brandPrimary
        secondaryHighlight = baseColor.brandSecondary

        primary = baseColor.primary
        secondary = baseColor.secondary

        onBrand = baseColor.white
        onPrimary = baseColor.contrastPrimary
    }
}

extension Color {
    static let theme = ThemeColor()
}
