//
//  ProfileSubmissionsView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 26.03.22.
//

import SwiftUI

struct ProfileSubmissionView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        switch viewModel.yearInfoAndYear {
        case .notRequested: notRequestedView
        case .isLoading: loadingView
        case let .loaded(yearInfoAndYear): loadedView(yearInfo: yearInfoAndYear.0, year: yearInfoAndYear.1)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

extension ProfileSubmissionView {
    private var notRequestedView: some View {
        Text("")
            .onAppear { viewModel.reloadYearInfo() }
    }

    private var loadingView: some View {
        ActivityIndicatorView(style: .medium)
    }

    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {
            viewModel.reloadYearInfo()
        }
    }
}

// MARK: - Displaying Content

extension ProfileSubmissionView {
    private func loadedView(yearInfo: WWDCYearInfo, year: WWDCYear) -> some View {
        let challengeDescription = (year.challengeDescription.map { $0 + " " } ?? "")
            + "Here’s how \(viewModel.scholar.givenName) describes his winning submission."

        return VStack(spacing: 18) {
            Text(challengeDescription)
                .font(.callout.italic())
                .foregroundColor(.secondary)

            Text(yearInfo.description)
                .font(.body)
                .foregroundColor(.primary)

            Text("\(yearInfo.screenshots.count) screenshots")

            if let githubLink = yearInfo.githubLink {
                Text("GitHub: \(githubLink)")
            }
            if let videoLink = yearInfo.videoLink {
                Text("Video: \(videoLink)")
            }
            if let appstoreLink = yearInfo.appstoreLink {
                Text("App Store: \(appstoreLink)")
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileSubmissionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSubmissionView(viewModel: .init(container: .preview, scholar: Scholar.mockData[0], yearRecordName: "WWDC 2021"))
    }
}
#endif
