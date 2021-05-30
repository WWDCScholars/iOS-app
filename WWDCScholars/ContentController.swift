//
//  ContentController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

protocol ContentController: AnyObject {
    var sectionContent: [SectionContent] { get set }

    func reloadContent()
    func add(sectionContent: SectionContent)
    func add(sectionContent: [SectionContent])
    func removeAllContent()
}

extension ContentController {

    // MARK: - Functions

    func numberOfSections() -> Int {
        return self.sectionContent.count
    }

    func numberOfItems(in section: Int) -> Int {
        return self.sectionContent[section].cellContent.count
    }

    func reuseIdentifier(for indexPath: IndexPath) -> String {
        return self.sectionContent[indexPath.section].cellContent[indexPath.item].reuseIdentifier
    }

    func cellContentFor(indexPath: IndexPath) -> CellContent {
        return self.sectionContentFor(index: indexPath.section).cellContent[indexPath.row]
    }
    
    func sectionContentFor(index: Int) -> SectionContent {
        return self.sectionContent[index]
    }
	
	func set(sectionContent: SectionContent) {
		self.sectionContent = [sectionContent]
	}

    func add(sectionContent: SectionContent) {
        self.sectionContent.append(sectionContent)
    }

    func add(sectionContent: [SectionContent]) {
        self.sectionContent.append(contentsOf: sectionContent)
    }

    func removeAllContent() {
        self.sectionContent.removeAll()
    }
    
    func indexPath(of cellContent: CellContent) -> IndexPath? {
        guard let sectionContentIndex = self.sectionContentIndex(of: cellContent) else {
            return nil
        }
        
        guard let cellContentIndex = self.index(of: cellContent, sectionContentIndex: sectionContentIndex) else {
            return nil
        }
        
        let indexPath = IndexPath(item: cellContentIndex, section: sectionContentIndex)
        return indexPath
    }
    
    func index(of cellContent: CellContent, sectionContentIndex: Int) -> Int? {
        guard let index = self.sectionContentFor(index: sectionContentIndex).cellContent.firstIndex(where: { $0 === cellContent }) else {
            return nil
        }
        
        return index
    }
    
    func sectionContentIndex(of cellContent: CellContent) -> Int? {
        guard let index = self.sectionContent.firstIndex(where: { $0.cellContent.contains(where: { $0 === cellContent }) }) else {
            return nil
        }
        
        return index
    }
}
