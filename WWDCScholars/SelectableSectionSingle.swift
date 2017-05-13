//
//  SelectableSectionSingle.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal protocol SelectableSectionSingle: class, Selectable {}

internal extension SelectableSectionSingle {

    // MARK: - internal Functions

    internal func performAction(on contentContainer: Reloadable?, with sectionContent: [SectionContent], at indexPath: IndexPath) {
        let cellContent = sectionContent[indexPath.section].cellContent
        let selectableContent = cellContent.flatMap({ $0 as? SelectableSectionSingle })
        let contentForDeselection = selectableContent.filter({ $0 !== self })
        _ = contentForDeselection.map({ $0.isSelected = false })
        self.isSelected = true

        let reloadIndexSet = IndexSet(integer: indexPath.section)
        contentContainer?.reload(sections: reloadIndexSet)
    }
}
