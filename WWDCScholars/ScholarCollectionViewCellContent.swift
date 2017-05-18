//
//  ScholarCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ScholarCollectionViewCellContent: CellContent, VariableWidthFixedHeightCollectionViewCellContent {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "scholarCollectionViewCell"
    internal let height: CGFloat = 140.0
    internal let axisCellCount = 3
    internal let scholar: ExampleScholar
    
    // MARK: - Lifecycle
    
    internal init(scholar: ExampleScholar) {
        self.scholar = scholar
    }
}
