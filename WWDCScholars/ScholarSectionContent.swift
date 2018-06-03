//
//  ScholarSectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class ScholarSectionContent: SectionContent, SizeableCollectionViewSectionContent {
    
    // MARK: - Internal Properties
    
    internal let id: String?
    internal let sizingModifiers: CollectionViewSectionContentSizingModifiers
    
    internal var cellContent = [CellContent]()
    internal var headerViewContent: HeaderFooterViewContent?
    internal var footerViewContent: HeaderFooterViewContent?
    
    // MARK: - Lifecycle
    
    internal init(id: String? = nil) {
        self.id = id
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        let minimumLineSpacing: CGFloat = 8.0
        let minimumInteritemSpacing: CGFloat = 8.0
        let sizingModifiers = CollectionViewSectionContentSizingModifiers(minimumLineSpacing: minimumLineSpacing, minimumInteritemSpacing: minimumInteritemSpacing, edgeInsets: edgeInsets)
        self.sizingModifiers = sizingModifiers
    }
}
