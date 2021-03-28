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
        case .notRequested:
            return AnyView(notRequestedView)
        case let .isLoading(last, _):
            return AnyView(loadingView(last))
        case let .loaded(scholars):
            return AnyView(loadedView(scholars, showSearch: true, showLoading: false))
        case let .failed(error):
            return AnyView(failedView(error))
        }
    }
}

// MARK: - Loading Content

extension ScholarsListView {
    private var notRequestedView: some View {
        Text("")
    }

    private func loadingView(_ previouslyLoaded: LazyList<Scholar>?) -> AnyView {
        if let scholars = previouslyLoaded {
            return AnyView(loadedView(scholars, showSearch: true, showLoading: true))
        }
        return AnyView(ActivityIndicatorView())
    }

    private func failedView(_ error: Error) -> some View {
        return ErrorView(error: error) {
            viewModel.reloadScholars()
        }
    }
}

// MARK: - Displaying Content

extension ScholarsListView {
    private func loadedView(_ scholars: LazyList<Scholar>, showSearch: Bool, showLoading: Bool) -> AnyView {
        if showLoading {
            return ActivityIndicatorView()
                .padding()
                .eraseToAnyView()
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
