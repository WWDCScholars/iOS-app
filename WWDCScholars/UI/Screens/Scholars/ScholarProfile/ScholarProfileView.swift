//
//  ScholarProfileView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 03.06.21.
//

import SwiftUI

struct ScholarProfileView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        switch viewModel.scholar {
        case .notRequested: notRequestedView
        case let .isLoading(last, _): loadingView(last)
        case let .loaded(scholar): loadedView(scholar)
        case let .failed(error): failedView(error)
        }
    }

}

// MARK: - Loading Content

extension ScholarProfileView {
    private var notRequestedView: some View {
        Text("")
            .onAppear { viewModel.loadScholar() }
    }

    @ViewBuilder
    private func loadingView(_ previouslyLoaded: Scholar?) -> some View {
        ActivityIndicatorView()

        if let scholar = previouslyLoaded {
            loadedView(scholar)
        }
    }

    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {
            viewModel.loadScholar()
        }
    }
}

// MARK: - Displaying Content

extension ScholarProfileView {
    private func loadedView(_ scholar: Scholar) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ProfileMapView(scholar: scholar)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 300)

                Rectangle()
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        ProfilePicture { viewModel.loadProfilePicture($0, of: scholar) }
                            .scaledToFill()
                    )
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 6))
                    .shadow(color: .black.opacity(0.16), radius: 6)
                    .offset(y: -100)
                    .padding(.bottom, -100)

                Spacer(minLength: 30)

                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 10) {
                            Text(scholar.fullName)
                                .foregroundColor(.theme.highlight)
                            Text("\(scholar.age)")
                                .foregroundColor(.theme.secondaryHighlight)
                        }
                        .font(.system(size: 28, weight: .bold))

                        Text(viewModel.readableLocation)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.theme.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                    Text(scholar.biography)
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    if let socialsViewModel = viewModel.socialsViewModel {
                        ProfileSocialsView(viewModel: socialsViewModel)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .foregroundColor(.theme.primary)
    }
}

// MARK: - Preview

struct ScholarProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ScholarProfileView(viewModel: .init(container: .preview, scholar: .loaded(Scholar.mockData[0]), scholarRecordName: ""))
    }
}
