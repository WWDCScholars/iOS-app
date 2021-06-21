//
//  ScholarsListView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

struct ScholarsListView: View {
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

        return List(scholars.sorted()) { scholar in
            NavigationLink(
                destination: profileView(scholar: scholar),
                tag: scholar.recordName,
                selection: $viewModel.routingState.scholarProfile,
                label: { ScholarCell(scholar: scholar) }
            )
        }
        .eraseToAnyView()
    }

    private func profileView(scholar: Scholar) -> some View {
        Text("Scholar \(scholar.fullName)")
//        ScholarProfileView(viewModel: .init(container: viewModel.container, scholar: scholar))
    }
}

// MARK: - Previews

#if DEBUG
struct ScholarsListView_Previews: PreviewProvider {
    static var previews: some View {
        ScholarsListView(viewModel: .init(container: .preview, selectedYear: "WWDC 2020"))
    }
}
#endif
