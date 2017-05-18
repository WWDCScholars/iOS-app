//
//  BatchCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BatchCollectionViewCellContent: CellContent, FixedSizeCollectionViewCellContent, SelectableSingleCellContent {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "batchCollectionViewCell"
    internal let width: CGFloat = 70.0
    internal let height: CGFloat = 30.0
    internal let batch: ExampleBatch
    
    internal var isSelected: Bool
    
    // MARK: - Lifecycle
    
    internal init(batch: ExampleBatch, isSelected: Bool = false) {
        self.batch = batch
        self.isSelected = isSelected
    }
}
