//
//  ScholarsViewControllerCellContentFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal final class ScholarsViewControllerCellContentFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func batchSectionContent(from batches: [ExampleBatch], delegate: BatchCollectionViewCellContentDelegate) -> SectionContent {
        let section = BatchSectionContent()
        for batch in batches {
            let batchCellContent = self.batchCellContent(from: batch, delegate: delegate)
            section.add(cellContent: batchCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func batchCellContent(from batch: ExampleBatch, delegate: BatchCollectionViewCellContentDelegate) -> CellContent {
        let cellContent = BatchCollectionViewCellContent(batch: batch, action: { [unowned delegate] in
            delegate.update(for: batch)
        })
        return cellContent
    }
}
