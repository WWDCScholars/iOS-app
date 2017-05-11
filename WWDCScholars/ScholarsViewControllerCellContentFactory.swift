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
    
    internal static func batchesSectionContent(from batches: [ExampleBatch]) -> SectionContent {
        let section = BasicSectionContent()
        for batch in batches {
            let batchCellContent = self.batchCellContent(from: batch)
            section.add(cellContent: batchCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func batchCellContent(from batch: ExampleBatch) -> CellContent {
        let cellContent = BatchCollectionViewCellContent(batch: batch)
        return cellContent
    }
}
