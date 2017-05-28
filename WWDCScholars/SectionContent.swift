//
//  SectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol SectionContent: class {
    var cellContent: [CellContent] { get set }
    var headerViewContent: HeaderFooterViewContent? { get set }
    var footerViewContent: HeaderFooterViewContent? { get set }
}

internal extension SectionContent {

    // MARK: - internal Functions

    internal func add(cellContent: CellContent) {
        self.cellContent.append(cellContent)
    }

    internal func add(cellContent: [CellContent]) {
        self.cellContent.append(contentsOf: cellContent)
    }

    internal func add(headerViewContent: HeaderFooterViewContent?) {
        self.headerViewContent = headerViewContent
    }

    internal func add(footerViewContent: HeaderFooterViewContent?) {
        self.footerViewContent = footerViewContent
    }
}
