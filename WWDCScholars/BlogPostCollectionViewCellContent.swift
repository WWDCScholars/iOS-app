//
//  BlogPostCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostCollectionViewCellContent: CellContent, VariableWidthFixedHeightCollectionViewCellContent, ActionableCellContent {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "blogPostCollectionViewCell"
    internal let height: CGFloat = 190.0
    internal let axisCellCount = 1
    internal let blogPost: BlogPost
    internal let action: () -> Void
    internal let id: String?
    
    // MARK: - Lifecycle
    
    internal init(id: String? = nil, blogPost: BlogPost, action: @escaping () -> Void) {
        self.id = id
        self.blogPost = blogPost
        self.action = action
    }
}
