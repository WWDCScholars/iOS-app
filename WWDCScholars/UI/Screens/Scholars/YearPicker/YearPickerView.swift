//
//  YearPickerView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import SwiftUI

struct YearPickerView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Binding private(set) var selectedYear: String? // TODO: This is unused, workaround for a bug that CapsulePicker view does not update when we don't this extra binding

    var body: some View {
        switch viewModel.years {
        case .notRequested: notRequestedView
        case let .isLoading(last, _): loadingView(last)
        case let .loaded(years): loadedView(years, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

extension YearPickerView {
    private var notRequestedView: some View {
        Text("").onAppear(perform: viewModel.reloadYears)
    }

    @ViewBuilder
    private func loadingView(_ previouslyLoaded: LazyList<WWDCYear>?) -> some View {
        if let years = previouslyLoaded {
            loadedView(years, showLoading: true)
        }
        ActivityIndicatorView()
    }

    private func failedView(_ error: Error) -> some View {
        return ErrorView(error: error) {
            viewModel.reloadYears()
        }
    }
}

// MARK: - Displaying Content

extension YearPickerView {
    private func loadedView(_ years: LazyList<WWDCYear>, showLoading: Bool) -> some View {
        let yearOptions = years.sorted()
            .map { ($0.year, $0.recordName) }

        return HStack {
            if showLoading {
                ActivityIndicatorView(style: .medium).padding()
            }

//            Picker("Pick", selection: viewModel.selectedYear) {
//                ForEach(yearOptions, id: \.0.self) { year in
//                    Text(year.0).tag(year.1 as String?)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())

            CapsulePicker(yearOptions, selection: viewModel.selectedYear)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct YearPickerView_Previews: PreviewProvider {
    static var previews: some View {
        YearPickerView(viewModel: .init(container: .preview, selectedYear: Binding.constant("WWDC 2020")), selectedYear: Binding.constant("WWDC 2020"))
            .background(Color.theme.brand)
    }
}
#endif
