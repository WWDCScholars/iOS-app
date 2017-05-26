//
//  ScholarAnnotation.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import ClusterKit

internal final class ScholarAnnotation: NSObject, CKAnnotation {
    
    // MARK: - Internal Properties
    
    internal let scholar: ExampleScholar
    internal let coordinate: CLLocationCoordinate2D
    
    weak internal var cluster: CKCluster?
    
    // MARK: - Lifecycle
    
    internal init(scholar: ExampleScholar) {
        self.scholar = scholar
        self.coordinate = scholar.location
    }
}
