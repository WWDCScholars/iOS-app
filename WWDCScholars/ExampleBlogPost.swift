//
//  ExampleBlogPost.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal protocol ExampleBlogPost {
    var title: String { get }
    var author: ExampleScholar { get }
    var heroImage: UIImage { get }
}

internal struct BlogPostOne: ExampleBlogPost {
    
    // MARK: - Internal Properties
    
    internal let title = "Meeting Apple Executives"
    internal let author: ExampleScholar = ScholarOne()
    internal let heroImage = UIImage(named: "blogPostHero")!
}
