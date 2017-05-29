//
//  ScholarCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class ScholarCollectionViewCellContent: CellContent, VariableWidthFixedHeightCollectionViewCellContent, ActionableCellContent {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "scholarCollectionViewCell"
    internal let height: CGFloat = 140.0
    internal let axisCellCount = 3
    internal let scholar: ExampleScholar
    internal let action: () -> Void
    
    // MARK: - Lifecycle
    
    internal init(scholar: ExampleScholar, action: @escaping () -> Void) {
        self.scholar = scholar
        self.action = action
    }
}
