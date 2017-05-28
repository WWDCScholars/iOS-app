//
//  ScholarsListViewControllerCellContentFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal final class ScholarsListViewControllerCellContentFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func scholarSectionContent(from scholars: [ExampleScholar], delegate: ScholarCollectionViewCellContentDelegate) -> SectionContent {
        let section = ScholarsSectionContent()
        for scholar in scholars {
            let scholarCellContent = self.scholarCellContent(from: scholar, delegate: delegate)
            section.add(cellContent: scholarCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func scholarCellContent(from scholar: ExampleScholar, delegate: ScholarCollectionViewCellContentDelegate) -> CellContent {
        let cellContent = ScholarCollectionViewCellContent(scholar: scholar, action: { [unowned delegate] in
            delegate.presentProfile(for: scholar)
        })
        return cellContent
    }
}
