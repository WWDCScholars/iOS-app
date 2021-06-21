//
//  ScholarThumbnailImage.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import SwiftUI

struct ScholarProfilePicture: View {
    let viewModel: ViewModel

    var body: some View {
        AsyncImage(viewModel: viewModel.cloudImageViewModel) { $0.resizable() }
    }
}

extension ScholarProfilePicture {
    final class ViewModel {
        private let container: DIContainer
        private let scholar: Scholar

        init(container: DIContainer, scholar: Scholar) {
            self.container = container
            self.scholar = scholar
        }

        var cloudImageViewModel: AsyncImage<AnyView>.ViewModel {
            .init(loadImage: {
                self.container.services.imagesService.loadProfilePicture($0, of: self.scholar)
            })
        }
    }
}
