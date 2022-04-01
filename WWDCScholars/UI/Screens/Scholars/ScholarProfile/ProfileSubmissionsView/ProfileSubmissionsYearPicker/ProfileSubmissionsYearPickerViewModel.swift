//
//  ProfileSubmissionsYearPickerViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

import SwiftUI

extension ProfileSubmissionsYearPickerView {
    final class ViewModel: ObservableObject {
        // State
        let scholar: Scholar
        let selectedYear: Binding<String?>

        // Misc
        let container: DIContainer

        init(container: DIContainer, scholar: Scholar, selectedYear: Binding<String?>) {
            self.container = container
            self.scholar = scholar
            self.selectedYear = selectedYear

            preselectLatestYear()
        }

        // MARK: Side Effects

        private func preselectLatestYear() {
            guard selectedYear.wrappedValue == nil, // only preselect if no value provided by parent
                  let lastYear = scholar.lastApprovedYearReference
            else { return }

            selectedYear.wrappedValue = lastYear.recordID.recordName
        }
    }
}
