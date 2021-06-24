//
//  AboutView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import SwiftUI

struct AboutView: View {
    enum Constants {
        static let heroTextPaddingVertical: CGFloat = 10
        static let heroTextPaddingHorizontal: CGFloat = 16
        static let heroImageMinHeight: CGFloat = 200
    }

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                teamHeroView
                AboutTeamMembersView(viewModel: .init(container: viewModel.container, showActiveTeamMembers: true))

                scholarsHeroView
                AboutFAQView(viewModel: .init(container: viewModel.container))

                Text("Past Contributors")
                    .font(.title2.bold())
                AboutTeamMembersView(viewModel: .init(container: viewModel.container, showActiveTeamMembers: false))

                Text("WWDCScholars is not affiliated with Apple Inc.")
            }
        }
    }

    private var teamHeroView: some View {
        Image("team-members")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, minHeight: Constants.heroImageMinHeight)
            .overlay(teamHeroText, alignment: .bottomLeading)
    }

    private var teamHeroText: some View {
        HStack(spacing: 0) {
            Text("WWDC")
            Text("Scholars")
                .fontWeight(.medium)
            Text(" Team")
        }
        .foregroundColor(.theme.onBrand)
        .font(.title2.bold())
        .padding(.vertical, Constants.heroTextPaddingVertical)
        .padding(.horizontal, Constants.heroTextPaddingHorizontal)
    }

    private var scholarsHeroView: some View {
        Image("team-scholars")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, minHeight: Constants.heroImageMinHeight)
            .overlay(scholarsHeroText, alignment: .bottomLeading)
    }

    private var scholarsHeroText: some View {
        Text("WWDC Scholarships")
            .foregroundColor(.theme.onBrand)
            .font(.title2.bold())
            .padding(.vertical, Constants.heroTextPaddingVertical)
            .padding(.horizontal, Constants.heroTextPaddingHorizontal)
    }
}

// MARK: - Preview

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(viewModel: .init(container: .preview))
    }
}
