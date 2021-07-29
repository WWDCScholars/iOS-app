//
//  AsyncImage.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import Combine
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private(set) var viewModel: ViewModel
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image

    init(viewModel: ViewModel, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        _viewModel = .init(wrappedValue: viewModel)
        self.placeholder = placeholder
        self.configuration = configuration
    }

    var body: some View {
        content
//            .onDisappear(perform: viewModel.cancel) // this does not work because onDisappear is called on every state transition of viewModel.image
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.image {
        case .notRequested: notRequestedView
        case .isLoading: loadingView
        case let .loaded(image): loadedView(image)
        case let .failed(error): failedView(error)
        }
    }
}

// MARK: - Content

extension AsyncImage {
    private var notRequestedView: some View {
        Group {
            if let placeholder = placeholder {
                placeholder
            } else {
                Rectangle()
                    .background(Color.theme.onPrimary)
            }
        }
        .onAppear(perform: viewModel.load)
    }

    private var loadingView: some View {
        ActivityIndicatorView(style: .medium)
    }

    func failedView(_ error: Error) -> some View {
        Image(systemName: "xmark")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
    }

    func loadedView(_ image: UIImage) -> some View {
        configuration(Image(uiImage: image))
    }
}

 // MARK: - ViewModel

extension AsyncImage {
    final class ViewModel: ObservableObject {
        // State
        @Published var image: Loadable<UIImage>

        // Misc
        private let loadImage: (LoadableSubject<UIImage>) -> CancelBag
        private var cancelBag: CancelBag?

        init(loadImage: @escaping (LoadableSubject<UIImage>) -> CancelBag, image: Loadable<UIImage> = .notRequested) {
            self.loadImage = loadImage
            _image = .init(initialValue: image)
        }

        // MARK: Side Effects

        func load() {
            cancelBag = loadImage(loadableSubject(\.image))
        }

        func cancel() {
            // TODO: Cancel loading when the image disappears from screen (i.e. scrolled out of view)
            cancelBag?.cancel()
        }
    }
}

// MARK: - Previews

struct CloudImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AsyncImage<AnyView>(viewModel: .init(loadImage: { _ in CancelBag() }, image: .isLoading(last: nil, cancelBag: CancelBag())))
                .previewDisplayName("isLoading")

            AsyncImage<AnyView>(viewModel: .init(loadImage: { _ in CancelBag() }, image: .failed(NotFoundError())))
                .previewDisplayName("failed")
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
