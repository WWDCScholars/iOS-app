//
//  BasicSectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal final class BasicSectionContent: SectionContent {
    
    // MARK: - Internal Properties
    
    internal var cellContent = [CellContent]()
    internal var headerViewContent: HeaderFooterViewContent?
    internal var footerViewContent: HeaderFooterViewContent?
}
