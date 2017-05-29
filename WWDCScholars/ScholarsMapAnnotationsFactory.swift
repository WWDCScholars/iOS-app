//
//  ScholarsMapAnnotationsFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class ScholarsMapAnnotationsFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func annotations(for scholars: [ExampleScholar]) -> [ScholarAnnotation] {
        return scholars.map({ ScholarAnnotation(scholar: $0) })
    }
}
