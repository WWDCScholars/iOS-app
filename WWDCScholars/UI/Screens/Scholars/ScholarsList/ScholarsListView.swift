//
//  ScholarsListView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

struct ScholarsListView: View {
    enum Constants {
        static let gridItemSize: CGFloat = 160
        static let gridSpacing: CGFloat = 15
    }

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        switch viewModel.scholars {
        case .notRequested: notRequestedView
        case let .isLoading(last, _): loadingView(last)
        case let .loaded(scholars): loadedView(scholars, showLoading: false)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

extension ScholarsListView {
    private var notRequestedView: some View {
        Text("")
    }

    @ViewBuilder
    private func loadingView(_ previouslyLoaded: LazyList<Scholar>?) -> some View {
        if let scholars = previouslyLoaded {
            loadedView(scholars, showLoading: true)
        }
        ActivityIndicatorView()
    }

    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {
            viewModel.reloadScholars()
        }
    }
}

// MARK: - Displaying Content

extension ScholarsListView {
    @ViewBuilder
    private func loadedView(_ scholars: LazyList<Scholar>, showLoading: Bool) -> some View {
        if showLoading {
            ActivityIndicatorView()
                .padding()
        }

        let items: [GridItem] = [
            .init(.adaptive(minimum: Constants.gridItemSize), spacing: Constants.gridSpacing)
        ]

        ScrollView(.vertical) {
            LazyVGrid(columns: items, alignment: .leading, spacing: Constants.gridSpacing) {
                ForEach(scholars) { scholar in
                    ScholarCell(container: viewModel.container, scholar: scholar)
                        .onTapGesture {
                            self.viewModel.routingState.scholarProfile = RecordName(scholar.recordName)
                        }
                }
            }
            .padding(15)
        }
        .sheet(item: $viewModel.routingState.scholarProfile, content: profileView(scholarRecordName:))
    }

    private func profileView(scholarRecordName: RecordName) -> some View {
        ScholarProfileView(viewModel: .init(container: viewModel.container, scholarRecordName: scholarRecordName.value))
    }
}

// MARK: - Previews

#if DEBUG
struct ScholarsListView_Previews: PreviewProvider {
    static var previews: some View {
        ScholarsListView(viewModel: .init(container: .preview, scholars: .loaded(Scholar.mockData.lazyList), selectedYear: "WWDC 2020"))
            .padding(15)
    }
}
#endif
