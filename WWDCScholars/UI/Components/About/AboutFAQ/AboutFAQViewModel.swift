//
//  AboutFAQViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.06.21.
//

import SwiftUI

extension AboutFAQView {
    final class ViewModel: ObservableObject {
        // State
        @Published private(set) var faqItems: Loadable<LazyList<FAQItem>>

        // Misc
        let container: DIContainer

        init(container: DIContainer, faqItems: Loadable<LazyList<FAQItem>> = .notRequested) {
            self.container = container
            _faqItems = .init(initialValue: faqItems)
        }

        // MARK: Side Effects

        func loadFAQItems() {
            container.services.aboutService
                .load(faqItems: loadableSubject(\.faqItems))
        }
    }
}
