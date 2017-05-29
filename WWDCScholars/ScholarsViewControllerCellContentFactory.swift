//
//  ScholarsViewControllerCellContentFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class ScholarsViewControllerCellContentFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func batchSectionContent(from batches: [ExampleBatch], delegate: BatchCollectionViewCellContentDelegate) -> BatchSectionContent {
        let section = BatchSectionContent()
        for batch in batches {
            let batchCellContent = self.batchCellContent(from: batch, delegate: delegate)
            section.add(cellContent: batchCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func batchCellContent(from batch: ExampleBatch, delegate: BatchCollectionViewCellContentDelegate) -> BatchCollectionViewCellContent {
        let cellContent = BatchCollectionViewCellContent(batch: batch, isSelected: batch.isDefault, action: { [unowned delegate] in
            delegate.update(for: batch)
        })
        return cellContent
    }
}
