//
//  BlogViewControllerCellContentFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal final class BlogViewControllerCellContentFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func blogPostSectionContent(from blogPosts: [ExampleBlogPost], delegate: BlogPostCollectionViewCellContentDelegate) -> BlogPostSectionContent {
        let section = BlogPostSectionContent()
        for blogPost in blogPosts {
            let blogPostCellContent = self.blogPostCellContent(from: blogPost, delegate: delegate)
            section.add(cellContent: blogPostCellContent)
        }
        return section
    }
    
    // MARK: - Private Functions
    
    private static func blogPostCellContent(from blogPost: ExampleBlogPost, delegate: BlogPostCollectionViewCellContentDelegate) -> BlogPostCollectionViewCellContent {
        let cellContent = BlogPostCollectionViewCellContent(blogPost: blogPost, action: { [unowned delegate] in
            delegate.open(blogPost: blogPost)
        })
        return cellContent
    }
}
