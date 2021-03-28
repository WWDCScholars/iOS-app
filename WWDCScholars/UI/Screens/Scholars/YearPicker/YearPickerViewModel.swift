//
//  YearPickerViewModel.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import SwiftUI


extension YearPickerView {
    final class ViewModel: ObservableObject {
        // State
        @Published var years: Loadable<LazyList<WWDCYear>>
        let selectedYear: Binding<String?>

        // Misc
        let container: DIContainer
        private let cancelBag = CancelBag()

        init(container: DIContainer, years: Loadable<LazyList<WWDCYear>> = .notRequested, selectedYear: Binding<String?>) {
            self.container = container
            _years = .init(initialValue: years)
            self.selectedYear = selectedYear
            cancelBag.collect {
                $years
                    .compactMap {
                        guard case let .loaded(years) = $0 else { return nil }
                        return years
                    }
                    .removeDuplicates()
                    .sink(receiveValue: preselectInitialYear(from:))
            }
        }

        // MARK: Side Effects

        func reloadYears() {
            container.services.yearsService
                .load(years: loadableSubject(\.years))
        }

        private func preselectInitialYear(from years: LazyList<WWDCYear>) {
            guard let lastYear = years.sorted().last else { return }
            selectedYear.wrappedValue = lastYear.recordName
        }
    }
}
