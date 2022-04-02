//
//  ProfileSubmissionsView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

import SwiftUI

struct ProfileSubmissionsView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Scholarships")
                .font(.title2.bold())
                .foregroundColor(.theme.brand)

            Text("\(viewModel.scholar.givenName) has been awarded a WWDC scholarship two times. Here are the submissions that got him there.")
                .font(.callout.italic())
                .foregroundColor(.secondary)

            ProfileSubmissionsYearPickerView(viewModel: viewModel.yearPickerViewModel, selectedYear: $viewModel.routingState.selectedYear)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.theme.brand)

            Text(viewModel.routingState.selectedYear ?? "no selection")

            ProfileSubmissionView(viewModel: .init(
                container: viewModel.container,
                scholar: viewModel.scholar,
                yearRecordName: viewModel.routingState.selectedYear
            ))
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileSubmissionsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSubmissionsView(viewModel: .init(container: .preview, scholar: Scholar.mockData[0]))
    }
}
#endif
