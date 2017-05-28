//
//  CollectionViewContentController+Batch.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 28/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal extension CollectionViewContentController {
    
    // MARK: - Internal Functions
    
    internal func selectSavedBatch() {
        guard let savedBatchSectionContent = self.sectionContent.last else {
            return
        }
        
        guard let savedBatchCellContent = savedBatchSectionContent.cellContent.last else {
            return
        }
        
        self.select(cellContent: savedBatchCellContent)
    }
    
    internal func scrollToSelectedBatch() {
        guard let sectionContentIndex = self.sectionContent.index(where: { $0.cellContent.contains(where: { ($0 as? BatchCollectionViewCellContent)?.isSelected == true }) }) else {
            return
        }
        
        guard let cellContentIndex = self.sectionContentFor(index: sectionContentIndex).cellContent.index(where: { ($0 as? BatchCollectionViewCellContent)?.isSelected == true }) else {
            return
        }
        
        let indexPath = IndexPath(item: cellContentIndex, section: sectionContentIndex)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
