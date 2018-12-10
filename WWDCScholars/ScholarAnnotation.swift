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
    
    internal let scholar: Scholar
    internal let coordinate: CLLocationCoordinate2D
    
    weak internal var cluster: CKCluster?
    
    // MARK: - Lifecycle
    
    internal init(scholar: Scholar) {
        self.scholar = scholar
        self.coordinate = scholar.location.coordinate
    }
}
