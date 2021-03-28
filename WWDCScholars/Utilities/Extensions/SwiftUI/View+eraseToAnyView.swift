//
//  View+EraseToAnyView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
