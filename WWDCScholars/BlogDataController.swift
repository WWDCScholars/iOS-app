//
//  BlogDataController.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 18/12/2018.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import Foundation

protocol BlogDataController {
    /// Returns all blogposts
    ///
    /// - Returns: An array of blog posts
    func blogPosts() -> [BlogPost]
    
    /// Gets a scholar identified by the id
    ///
    /// - Parameter id: Identifier of the blog post to retrieve
    /// - Returns: Returns the blogpost with given id or nil
    func blogPost(for id: UUID) -> BlogPost?
    
    /// Returns the amount of blog posts in the database
    ///
    /// - Returns: The number of blog posts in the database
    func countPosts() -> Int
    
    /// Add blog post to the database
    ///
    /// - Parameter post: BlogPost to add
    func add(_ post: BlogPost)
    
    /// Removes blog post from a database
    ///
    /// - Parameter post: BlogPost to remove
    func remove(_ post: BlogPost)
    
    /// Update blog post in database
    ///
    /// - Parameter post: BlogPost to update
    func update(_ post: BlogPost)
}

protocol BlogIterator: IteratorProtocol where Element == BlogPost {
    init(_ dataController: BlogDataController)
}
