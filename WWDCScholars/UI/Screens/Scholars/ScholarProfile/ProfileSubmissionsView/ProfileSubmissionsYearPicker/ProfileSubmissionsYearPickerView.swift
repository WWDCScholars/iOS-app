//
//  ProfileSubmissionsYearPickerView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

import SwiftUI

struct ProfileSubmissionsYearPickerView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Binding private(set) var selectedYear: String? // dummy

    var body: some View {
        let yearOptions = viewModel.scholar.wwdcYearsApproved
            .map { yearReference -> (String, String) in
                let label = String(yearReference.recordID.recordName.suffix(4))
                return (label, yearReference.recordID.recordName)
            }

        CapsulePicker(yearOptions, selection: viewModel.selectedYear)
    }
}

// MARK: - Preview

struct ProfileSubmissionsYearPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSubmissionsYearPickerView(
            viewModel: .init(
                container: .preview,
                scholar: Scholar.mockData[0],
                selectedYear: .constant("WWDC 2020")
            ),
            selectedYear: .constant("WWDC 2020")
        )
            .background(Color.theme.brand)
    }
}
