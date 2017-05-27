//
//  BlogPostCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostCollectionViewCellContent: CellContent, VariableWidthFixedHeightCollectionViewCellContent, ActionableCellContent {
    
    // MARK: - Internal Properties
    
    internal let reuseIdentifier = "blogPostCollectionViewCell"
    internal let height: CGFloat = 190.0
    internal let axisCellCount = 1
    internal let blogPost: ExampleBlogPost
    internal let action: () -> Void
    
    // MARK: - Lifecycle
    
    internal init(blogPost: ExampleBlogPost, action: @escaping () -> Void) {
        self.blogPost = blogPost
        self.action = action
    }
}
