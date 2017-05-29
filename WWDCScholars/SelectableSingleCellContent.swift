//
//  SelectableSingle.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol SelectableSingleCellContent: class, SelectableCellContent {}

internal extension SelectableSingleCellContent {

    // MARK: - internal Functions

    internal func select(on contentContainer: ReloadableContentContainer?, with sectionContent: [SectionContent], at indexPath: IndexPath) {
        let selectableContent = sectionContent.flatMap({ $0.cellContent.flatMap({ $0 as? SelectableSingleCellContent }) })
        let contentForDeselection = selectableContent.filter({ $0 !== self })
        _ = contentForDeselection.map({ $0.isSelected = false })
        self.isSelected = true

        let upperRangeBound = sectionContent.count
        let range = Range(uncheckedBounds: (0, upperRangeBound))
        let indexSet = IndexSet(integersIn: range)
        contentContainer?.reload(sections: indexSet)
    }
}
