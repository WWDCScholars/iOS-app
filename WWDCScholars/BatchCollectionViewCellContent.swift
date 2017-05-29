//
//  BatchCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class BatchCollectionViewCellContent: CellContent, FixedSizeCollectionViewCellContent, SelectableSingleCellContent, ActionableCellContent {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "batchCollectionViewCell"
    internal let width: CGFloat = 70.0
    internal let height: CGFloat = 30.0
    internal let batch: ExampleBatch
    internal let action: () -> Void
    
    internal var isSelected: Bool
    
    // MARK: - Lifecycle
    
    internal init(batch: ExampleBatch, isSelected: Bool = false, action: @escaping () -> Void) {
        self.batch = batch
        self.isSelected = isSelected
        self.action = action
    }
}
