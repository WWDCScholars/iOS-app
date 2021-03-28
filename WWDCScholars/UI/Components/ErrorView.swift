//
//  ErrorView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
                .padding()
            Button(action: retryAction, label: { Text("Retry").bold() })
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"]),
            retryAction: {}
        )
    }
}
#endif
