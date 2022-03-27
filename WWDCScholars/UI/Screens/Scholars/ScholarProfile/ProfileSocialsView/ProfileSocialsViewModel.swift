//
//  ProfileSocialsViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 19.06.21.
//

import SwiftUI

extension ProfileSocialsView {
    final class ViewModel: ObservableObject {
        // State
        @Published var socialMedia: Loadable<ScholarSocialMedia>
        private let scholar: Scholar

        // Misc
        let container: DIContainer

        init(container: DIContainer, socialMedia: Loadable<ScholarSocialMedia> = .notRequested, scholar: Scholar) {
            self.container = container
            _socialMedia = .init(initialValue: socialMedia)
            self.scholar = scholar
        }

        // MARK: Side Effects

        func loadSocialMedia() {
            container.services.scholarsService
                .load(
                    socialMedia: loadableSubject(\.socialMedia),
                    scholar: scholar
                )
        }
    }
}
