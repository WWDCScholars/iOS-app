//
//  ProfileSocialsView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 11.06.21.
//

import SwiftUI

struct ProfileSocialsView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        switch viewModel.socialMedia {
        case .notRequested: notRequestedView
        case .isLoading: loadingView
        case let .loaded(socialMedia): loadedView(socialMedia)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

extension ProfileSocialsView {
    private var notRequestedView: some View {
        Text("")
            .onAppear { viewModel.loadSocialMedia() }
    }

    private var loadingView: some View {
        ActivityIndicatorView(style: .medium)
    }

    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {}
    }
}

// MARK: - Displaying Content

extension ProfileSocialsView {
    private func loadedView(_ socialMedia: ScholarSocialMedia) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                if let twitter = socialMedia.twitter {
                    socialButton(to: twitter, icon: "twitter")
                }
                if let instagram = socialMedia.instagram {
                    socialButton(to: instagram, icon: "instagram")
                }
                if let github = socialMedia.github {
                    socialButton(to: github, icon: "github")
                }
                if let linkedin = socialMedia.linkedin {
                    socialButton(to: linkedin, icon: "linkedin")
                }
                if let imessage = socialMedia.imessage {
                    socialButton(to: imessage, icon: "messages")
                }
                if let facebook = socialMedia.facebook {
                    socialButton(to: facebook, icon: "facebook")
                }
                if let itunes = socialMedia.itunes {
                    socialButton(to: itunes, icon: "appstore")
                }
                if let website = socialMedia.website {
                    socialButton(to: website, icon: "website")
                }
                if let discord = socialMedia.discord {
                    socialButton(to: discord, icon: "discord")
                }
            }
        }
    }

    private func socialButton(to destination: String, icon: String) -> some View {
        Button(action: {}) {
            Image("icon-\(icon)")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(4)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileSocialsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSocialsView(viewModel: .init(container: .preview, scholar: Scholar.mockData[0]))
            .previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
