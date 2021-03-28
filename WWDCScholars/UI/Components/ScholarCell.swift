//
//  ScholarCell.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import SwiftUI

struct ScholarCell: View {
    let scholar: Scholar

    var body: some View {
        VStack(alignment: .leading) {
            Text(scholar.fullName)
                .font(.title)
            Text(scholar.recordName)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
    }
}

#if DEBUG
struct ScholarCell_Previews: PreviewProvider {
    static var previews: some View {
        ScholarCell(scholar: Scholar.mockData[0])
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
