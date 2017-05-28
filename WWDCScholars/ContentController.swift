//
//  ContentController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal protocol ContentController: class {
    var sectionContent: [SectionContent] { get set }

    func reloadContent()
    func add(sectionContent: SectionContent)
    func add(sectionContent: [SectionContent])
    func removeAllContent()
}

internal extension ContentController {

    // MARK: - internal Functions

    internal func numberOfSections() -> Int {
        return self.sectionContent.count
    }

    internal func numberOfItems(in section: Int) -> Int {
        return self.sectionContent[section].cellContent.count
    }

    internal func reuseIdentifier(for indexPath: IndexPath) -> String {
        return self.sectionContent[indexPath.section].cellContent[indexPath.item].reuseIdentifier
    }

    internal func cellContentFor(indexPath: IndexPath) -> CellContent {
        return self.sectionContentFor(index: indexPath.section).cellContent[indexPath.row]
    }
    
    internal func sectionContentFor(index: Int) -> SectionContent {
        return self.sectionContent[index]
    }

    internal func add(sectionContent: SectionContent) {
        self.sectionContent.append(sectionContent)
    }

    internal func add(sectionContent: [SectionContent]) {
        self.sectionContent.append(contentsOf: sectionContent)
    }

    internal func removeAllContent() {
        self.sectionContent.removeAll()
    }
    
    internal func indexPath(of cellContent: CellContent) -> IndexPath? {
        guard let sectionContentIndex = self.sectionContentIndex(of: cellContent) else {
            return nil
        }
        
        guard let cellContentIndex = self.index(of: cellContent, sectionContentIndex: sectionContentIndex) else {
            return nil
        }
        
        let indexPath = IndexPath(item: cellContentIndex, section: sectionContentIndex)
        return indexPath
    }
    
    internal func index(of cellContent: CellContent, sectionContentIndex: Int) -> Int? {
        guard let index = self.sectionContentFor(index: sectionContentIndex).cellContent.index(where: { $0 === cellContent }) else {
            return nil
        }
        
        return index
    }
    
    internal func sectionContentIndex(of cellContent: CellContent) -> Int? {
        guard let index = self.sectionContent.index(where: { $0.cellContent.contains(where: { $0 === cellContent }) }) else {
            return nil
        }
        
        return index
    }
}
