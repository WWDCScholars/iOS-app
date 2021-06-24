//
//  AboutViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import SwiftUI

extension AboutView {
    final class ViewModel: ObservableObject {
        let container: DIContainer

        init(container: DIContainer) {
            self.container = container
        }
    }
}
