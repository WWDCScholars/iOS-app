//
//  ProfileSubmissionsViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 26.03.22.
//

import SwiftUI

extension ProfileSubmissionView {
    final class ViewModel: ObservableObject {
        // State
        @Published var yearInfoAndYear: Loadable<(WWDCYearInfo, WWDCYear)>
        let scholar: Scholar
        private let yearRecordName: String

        // Misc
        let container: DIContainer

        init(container: DIContainer, yearInfoAndYear: Loadable<(WWDCYearInfo, WWDCYear)> = .notRequested, scholar: Scholar, yearRecordName: String) {
            self.container = container
            _yearInfoAndYear = .init(initialValue: yearInfoAndYear)
            self.scholar = scholar
            self.yearRecordName = yearRecordName
        }

        // MARK: Side Effects

        func loadYearInfo() {
            container.services.scholarsService
                .load(
                    yearInfoAndYear: loadableSubject(\.yearInfoAndYear),
                    scholar: scholar,
                    yearRecordName: yearRecordName
                )
        }
    }
}
