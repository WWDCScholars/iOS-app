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
    
    internal static func batchSectionContent(from batchInfos: [BatchInfo], delegate: BatchCollectionViewCellContentDelegate) -> BatchSectionContent {
        let sectionID = "Batches"
        let section = BatchSectionContent(id: sectionID)
        for batchInfo in batchInfos {
            let batchCellContent = self.batchCellContent(from: batchInfo, delegate: delegate)
            section.add(cellContent: batchCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func batchCellContent(from batchInfo: BatchInfo, delegate: BatchCollectionViewCellContentDelegate) -> BatchCollectionViewCellContent {
        let cellContent = BatchCollectionViewCellContent(batchInfo: batchInfo, action: { [unowned delegate] in
            delegate.update(for: batchInfo)
        })
        return cellContent
    }
}
