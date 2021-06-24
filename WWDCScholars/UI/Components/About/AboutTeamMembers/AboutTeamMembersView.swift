//
//  AboutTeamMembersView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.06.21.
//

import SwiftUI

struct AboutTeamMembersView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        switch viewModel.teamMembers {
        case .notRequested: notRequestedView
        case let .isLoading(last, _): loadingView(last)
        case let .loaded(teamMembers): loadedView(teamMembers)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

extension AboutTeamMembersView {
    private var notRequestedView: some View {
        Text("")
            .onAppear(perform: viewModel.loadTeamMembers)
    }

    @ViewBuilder
    private func loadingView(_ previouslyLoaded: LazyList<TeamMember>?) -> some View {
        ActivityIndicatorView()
            .padding()

        if let previouslyLoaded = previouslyLoaded {
            loadedView(previouslyLoaded)
        }
    }

    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {}
    }
}

// MARK: - Displaying Content

extension AboutTeamMembersView {
    @ViewBuilder
    private func loadedView(_ faqItems: LazyList<TeamMember>) -> some View {
        Text("\(faqItems.count) team members")
    }
}

// MARK: - Preview

struct AboutTeamMembersView_Previews: PreviewProvider {
    static var previews: some View {
        AboutTeamMembersView(viewModel: .init(container: .preview, showActiveTeamMembers: true))
    }
}
