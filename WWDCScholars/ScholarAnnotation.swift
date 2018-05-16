//
//  ScholarAnnotation.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import ClusterKit

internal final class ScholarAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Internal Properties
    
    internal let scholar: BasicScholar
    internal let coordinate: CLLocationCoordinate2D
    
    weak internal var cluster: CKCluster?
    
    // MARK: - Lifecycle
    
    internal init(scholar: BasicScholar) {
        self.scholar = scholar
        self.coordinate = scholar.location.coordinate
    }
}
