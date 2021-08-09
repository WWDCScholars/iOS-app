//
//  AboutTeamMembersViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.06.21.
//

import SwiftUI

extension AboutTeamMembersView {
    final class ViewModel: ObservableObject {
        // State
        @Published private(set) var teamMembers: Loadable<LazyList<TeamMember>>
        private(set) var showActiveTeamMembers: Bool

        // Misc
        let container: DIContainer

        init(container: DIContainer, teamMembers: Loadable<LazyList<TeamMember>> = .notRequested, showActiveTeamMembers: Bool) {
            self.container = container
            _teamMembers = .init(initialValue: teamMembers)
            self.showActiveTeamMembers = showActiveTeamMembers
        }

        // MARK: Side Effects

        func loadTeamMembers() {
            container.services.aboutService
                .load(
                    teamMembers: loadableSubject(\.teamMembers),
                    isActive: showActiveTeamMembers
                )
        }

        func loadPicture(_ image: LoadableSubject<UIImage>, of teamMember: TeamMember) -> CancelBag {
            container.services.imagesService.loadPicture(image, of: teamMember)
        }
    }
}
