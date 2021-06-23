//
//  ScholarsView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 25.03.21.
//

import SwiftUI

struct ScholarsView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 0) {
                            Text("WWDC")
                                .font(.system(size: 17, weight: .semibold, design: .default))
                            Text("Scholars")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.white)
                    }
                }
                .purpleNavigationBar
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            YearPickerView(viewModel: viewModel.yearPickerViewModel, selectedYear: $viewModel.routingState.selectedYear)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.theme.brand)

            ScholarsListView(viewModel: .init(container: viewModel.container, selectedYear: viewModel.routingState.selectedYear))
                .frame(maxHeight: .infinity)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ScholarsView_Preview: PreviewProvider {
    static var previews: some View {
        ScholarsView(viewModel: .init(container: .preview))
    }
}
#endif
