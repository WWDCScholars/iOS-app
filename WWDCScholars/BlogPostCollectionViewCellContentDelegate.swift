//
//  BlogPostCollectionViewCellContentDelegate.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol BlogPostCollectionViewCellContentDelegate: class {
    func open(blogPost: BlogPost)
}
