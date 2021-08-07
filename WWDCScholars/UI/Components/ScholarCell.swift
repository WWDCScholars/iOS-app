//
//  ScholarCell.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

struct ScholarCell: View {
    let container: DIContainer
    let scholar: Scholar

    var body: some View {
        content
    }

    private var content: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .aspectRatio(1, contentMode: .fill)
                .overlay(
                    ProfilePicture { container.services.imagesService.loadProfilePicture($0, of: scholar) }
                        .scaledToFill()
                )

            Text(scholar.givenName)
                .font(.title2.weight(.medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(Color.theme.brand.opacity(0.75))
        }
        .cornerRadius(20)
    }
}

// MARK: - Previews

struct ScholarCell_Previews: PreviewProvider {
    static var previews: some View {
        ScholarCell(container: .preview, scholar: Scholar.mockData[0])
            .previewLayout(.fixed(width: 160, height: 160))
    }
}
