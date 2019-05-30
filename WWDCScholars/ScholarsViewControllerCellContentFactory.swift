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
    
    internal static func batchSectionContent(from batchInfos: [WWDCYear], delegate: WWDCYearInfoCollectionViewCellContentDelegate) -> WWDCYearInfoSectionContent {
        let sectionID = "WWDCYearInfos"
        let section = WWDCYearInfoSectionContent(id: sectionID)
        for batchInfo in batchInfos {
            let batchCellContent = self.batchCellContent(from: batchInfo, delegate: delegate)
            section.add(cellContent: batchCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func batchCellContent(from batchInfo: WWDCYear, delegate: WWDCYearInfoCollectionViewCellContentDelegate) -> WWDCYearInfoCollectionViewCellContent {
        let cellContent = WWDCYearInfoCollectionViewCellContent(batchInfo: batchInfo, action: { [unowned delegate] in
            delegate.update(for: batchInfo)
        })
        return cellContent
    }
}
