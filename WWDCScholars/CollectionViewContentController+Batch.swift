//
//  CollectionViewContentController+WWDCYearInfo.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 28/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

extension CollectionViewContentController {
    
    // MARK: - Functions
    
    func selectSavedWWDCYearInfo() {
        guard let savedWWDCYearInfoSectionContent = self.sectionContent.filter({ $0.id == "WWDCYearInfos" }).first else {
            return
        }
        
        guard let savedWWDCYearInfoCellContent = savedWWDCYearInfoSectionContent.cellContent.filter({ $0.id == "Saved" }).first else {
            return
        }
        
        self.select(cellContent: savedWWDCYearInfoCellContent)
    }
    
    func selectDefaultWWDCYearInfo() {
        guard let defaultWWDCYearInfoSectionContent = self.sectionContent.filter({ $0.id == "WWDCYearInfos" }).first else {
            return
        }
        
        guard let defaultWWDCYearInfoCellContent = defaultWWDCYearInfoSectionContent.cellContent.filter({ ($0 as? WWDCYearInfoCollectionViewCellContent)?.batchInfo.isDefault == true }).first else {
            return
        }
        
        self.select(cellContent: defaultWWDCYearInfoCellContent)
    }
    
    func scrollToSelectedWWDCYearInfo() {
        guard let sectionContentIndex = self.sectionContent.firstIndex(where: { $0.cellContent.contains(where: { ($0 as? WWDCYearInfoCollectionViewCellContent)?.isSelected == true }) }) else {
            return
        }
        
        guard let cellContentIndex = self.sectionContentFor(index: sectionContentIndex).cellContent.firstIndex(where: { ($0 as? WWDCYearInfoCollectionViewCellContent)?.isSelected == true }) else {
            return
        }
        
        let indexPath = IndexPath(item: cellContentIndex, section: sectionContentIndex)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
