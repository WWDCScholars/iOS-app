//
//  AboutFAQView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.06.21.
//

import SwiftUI

struct AboutFAQView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        switch viewModel.faqItems {
        case .notRequested: notRequestedView
        case let .isLoading(last, _): loadingView(last)
        case let .loaded(faqItems): loadedView(faqItems)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Loading Content

extension AboutFAQView {
    private var notRequestedView: some View {
        Text("")
            .onAppear(perform: viewModel.loadFAQItems)
    }

    @ViewBuilder
    private func loadingView(_ previouslyLoaded: LazyList<FAQItem>?) -> some View {
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

extension AboutFAQView {
    @ViewBuilder
    private func loadedView(_ faqItems: LazyList<FAQItem>) -> some View {
        Text("\(faqItems.count) faq items")
    }
}

// MARK: - Preview

struct AboutFAQView_Previews: PreviewProvider {
    static var previews: some View {
        AboutFAQView(viewModel: .init(container: .preview))
    }
}
