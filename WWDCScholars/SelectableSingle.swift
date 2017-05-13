//
//  SelectableSingle.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal protocol SelectableSingle: class, Selectable {}

internal extension SelectableSingle {

    // MARK: - internal Functions

    internal func performAction(on contentContainer: Reloadable?, with sectionContent: [SectionContent], at indexPath: IndexPath) {
        let selectableContent = sectionContent.flatMap({ $0.cellContent.flatMap({ $0 as? SelectableSingle }) })
        let contentForDeselection = selectableContent.filter({ $0 !== self })
        _ = contentForDeselection.map({ $0.isSelected = false })
        self.isSelected = true

        let upperRangeBound = sectionContent.count
        let range = Range(uncheckedBounds: (0, upperRangeBound))
        let indexSet = IndexSet(integersIn: range)
        contentContainer?.reload(sections: indexSet)
    }
}
