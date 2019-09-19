//
//  SelectableSectionSingle.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

protocol SelectableSectionSingleCellContent: SelectableCellContent {}

extension SelectableSectionSingleCellContent {

    // MARK: - Functions

    func select(on contentContainer: ReloadableContentContainer?, with sectionContent: [SectionContent], at indexPath: IndexPath) {
        let cellContent = sectionContent[indexPath.section].cellContent
        let selectableContent = cellContent.compactMap({ $0 as? SelectableSectionSingleCellContent })
        let contentForDeselection = selectableContent.filter({ $0 !== self })
        _ = contentForDeselection.map({ $0.isSelected = false })
        self.isSelected = true

        let reloadIndexSet = IndexSet(integer: indexPath.section)
        contentContainer?.reload(sections: reloadIndexSet)
    }
}
