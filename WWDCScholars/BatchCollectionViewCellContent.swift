//
//  BatchCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal final class BatchCollectionViewCellContent: CellContent, SelectableSingle {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "batchCollectionViewCell"
    internal let batch: ExampleBatch
    
    internal var isSelected: Bool
    
    // MARK: - Lifecycle
    
    internal init(batch: ExampleBatch, isSelected: Bool = false) {
        self.batch = batch
        self.isSelected = isSelected
    }
}
