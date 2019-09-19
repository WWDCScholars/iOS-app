//
//  SectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

protocol SectionContent: class {
    var cellContent: [CellContent] { get set }
    var headerViewContent: HeaderFooterViewContent? { get set }
    var footerViewContent: HeaderFooterViewContent? { get set }
    var id: String? { get }
}

extension SectionContent {

    // MARK: - Functions

    func add(cellContent: CellContent) {
        self.cellContent.append(cellContent)
    }

    func add(cellContent: [CellContent]) {
        self.cellContent.append(contentsOf: cellContent)
    }

    func add(headerViewContent: HeaderFooterViewContent?) {
        self.headerViewContent = headerViewContent
    }

    func add(footerViewContent: HeaderFooterViewContent?) {
        self.footerViewContent = footerViewContent
    }
}
