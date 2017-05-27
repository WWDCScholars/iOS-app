//
//  BlogPostSectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostSectionContent: SectionContent, SizeableCollectionViewSectionContent {
    
    // MARK: - Internal Properties
    
    internal let sizingModifiers: CollectionViewSectionContentSizingModifiers
    
    internal var cellContent = [CellContent]()
    internal var headerViewContent: HeaderFooterViewContent?
    internal var footerViewContent: HeaderFooterViewContent?
    
    // MARK: - Lifecycle
    
    internal init() {
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        let minimumLineSpacing: CGFloat = 8.0
        let minimumInteritemSpacing: CGFloat = 8.0
        let sizingModifiers = CollectionViewSectionContentSizingModifiers(minimumLineSpacing: minimumLineSpacing, minimumInteritemSpacing: minimumInteritemSpacing, edgeInsets: edgeInsets)
        self.sizingModifiers = sizingModifiers
    }
}
