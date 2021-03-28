//
//  ContentView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

// MARK: - View

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        ScholarsView(viewModel: .init(container: viewModel.container))
    }
}

// MARK: - ViewModel

extension ContentView {
    final class ViewModel: ObservableObject {
        let container: DIContainer

        init(container: DIContainer) {
            self.container = container
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(container: .preview))
    }
}
