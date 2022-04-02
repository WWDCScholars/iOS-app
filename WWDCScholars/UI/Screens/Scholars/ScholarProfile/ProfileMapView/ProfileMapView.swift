//
//  ProfileMapView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 11.06.21.
//

import MapKit
import SwiftUI
import CloudKit

struct ProfileMapView: View {
    enum Constants {
        static let mapSpan: CLLocationDegrees = 8.0
    }

    let scholar: Scholar

    private var annotations: [ScholarAnnotatable] {
        [.init(id: scholar.recordName, coordinate: scholar.location.coordinate)]
    }

    private var region: Binding<MKCoordinateRegion> {
        .constant(.init(
            center: scholar.location.coordinate,
            span: .init(latitudeDelta: Constants.mapSpan, longitudeDelta: Constants.mapSpan)
        ))
    }

    var body: some View {
        Map(coordinateRegion: region, annotationItems: annotations) { annotatable in
            MapMarker(coordinate: annotatable.coordinate, tint: .theme.brand)
        }
    }
}

// MARK: - ScholarAnnotatable

extension ProfileMapView {
    struct ScholarAnnotatable: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileMapView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMapView(scholar: Scholar.mockData[0])
    }
}
#endif
