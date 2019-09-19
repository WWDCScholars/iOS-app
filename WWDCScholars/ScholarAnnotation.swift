//
//  ScholarAnnotation.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import MapKit

final class ScholarAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    let scholar: Scholar
    
    // MARK: - Lifecycle
    
    init(scholar: Scholar) {
        self.scholar = scholar
    }

    // MARK: - Computed Properties

    var title: String? {
        return scholar.givenName
    }

    var coordinate: CLLocationCoordinate2D {
        return scholar.location.coordinate
    }

    var image: UIImage? {
        return scholar.profilePicture?.image
    }
}
