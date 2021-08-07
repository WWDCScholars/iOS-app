//
//  ProfilePicture.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import SwiftUI

struct ProfilePicture: View {
    let loadImage: (LoadableSubject<UIImage>) -> CancelBag

    var body: some View {
        AsyncImage(viewModel: cloudImageViewModel) { $0.resizable() }
    }

    private var cloudImageViewModel: AsyncImage<AnyView>.ViewModel {
        .init(loadImage: loadImage)
    }
}
