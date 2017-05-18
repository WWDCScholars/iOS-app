//
//  SelectableSectionSingle.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal protocol SelectableSectionSingleCellContent: class, SelectableCellContent {}

internal extension SelectableSectionSingleCellContent {

    // MARK: - internal Functions

    internal func performAction(on contentContainer: ReloadableContentContainer?, with sectionContent: [SectionContent], at indexPath: IndexPath) {
        let cellContent = sectionContent[indexPath.section].cellContent
        let selectableContent = cellContent.flatMap({ $0 as? SelectableSectionSingleCellContent })
        let contentForDeselection = selectableContent.filter({ $0 !== self })
        _ = contentForDeselection.map({ $0.isSelected = false })
        self.isSelected = true

        let reloadIndexSet = IndexSet(integer: indexPath.section)
        contentContainer?.reload(sections: reloadIndexSet)
    }
}
