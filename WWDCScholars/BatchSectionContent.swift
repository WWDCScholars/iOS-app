//
//  BatchSectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BatchSectionContent: SectionContent, SizeableCollectionViewSectionContent {
    
    // MARK: - Internal Properties
    
    internal let sizingModifiers: CollectionViewSectionContentSizingModifiers
    
    internal var cellContent = [CellContent]()
    internal var headerViewContent: HeaderFooterViewContent?
    internal var footerViewContent: HeaderFooterViewContent?
    
    // MARK: - Lifecycle
    
    internal init() {
        let edgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        let minimumLineSpacing: CGFloat = 8.0
        let minimumInteritemSpacing: CGFloat = 8.0
        let sizingModifiers = CollectionViewSectionContentSizingModifiers(minimumLineSpacing: minimumLineSpacing, minimumInteritemSpacing: minimumInteritemSpacing, edgeInsets: edgeInsets)
        self.sizingModifiers = sizingModifiers
    }
}
