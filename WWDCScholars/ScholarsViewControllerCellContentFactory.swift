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
        let section = BatchSectionContent()
        for batch in batches {
            let batchCellContent = self.batchCellContent(from: batch)
            section.add(cellContent: batchCellContent)
        }
        return section
    }
    
    internal static func scholarSectionContent(from scholars: [ExampleScholar]) -> SectionContent {
        let section = ScholarsSectionContent()
        for scholar in scholars {
            let scholarCellContent = self.scholarCellContent(from: scholar)
            section.add(cellContent: scholarCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func batchCellContent(from batch: ExampleBatch) -> CellContent {
        let cellContent = BatchCollectionViewCellContent(batch: batch)
        return cellContent
    }
    
    private static func scholarCellContent(from scholar: ExampleScholar) -> CellContent {
        let cellContent = ScholarCollectionViewCellContent(scholar: scholar)
        return cellContent
    }
}
