//
//  CollectionViewContentController+Batch.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 28/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal extension CollectionViewContentController {
    
    // MARK: - Internal Functions
    
    internal func selectSavedBatch() {
        guard let savedBatchSectionContent = self.sectionContent.filter({ $0.id == "Batches" }).first else {
            return
        }
        
        guard let savedBatchCellContent = savedBatchSectionContent.cellContent.filter({ $0.id == "Saved" }).first else {
            return
        }
        
        self.select(cellContent: savedBatchCellContent)
    }
    
    internal func selectDefaultBatch() {
        guard let defaultBatchSectionContent = self.sectionContent.filter({ $0.id == "Batches" }).first else {
            return
        }
        
        guard let defaultBatchCellContent = defaultBatchSectionContent.cellContent.filter({ ($0 as? BatchCollectionViewCellContent)?.batchInfo.isDefault == true }).first else {
            return
        }
        
        self.select(cellContent: defaultBatchCellContent)
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
