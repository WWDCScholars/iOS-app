//
//  BlogViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let blogPostCollectionViewContentController = CollectionViewContentController()
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView?
    
    fileprivate let cellHeight: CGFloat = 184.0
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.configureBlogPostContentController()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
    }
    
    private func configureUI() {
        self.title = "Blog"
    }
    
    // MARK: - Private Functions
    
    private func configureBlogPostContentController() {
        self.blogPostCollectionViewContentController.configure(collectionView: self.collectionView)
        
        let blogPosts: [ExampleBlogPost] = [BlogPostOne()]
        let blogPostSectionContent = BlogViewControllerCellContentFactory.blogPostSectionContent(from: blogPosts, delegate: self)
        
        self.blogPostCollectionViewContentController.add(sectionContent: blogPostSectionContent)
        self.blogPostCollectionViewContentController.reloadContent()
    }
}

extension BlogViewController: BlogPostCollectionViewCellContentDelegate {
    
    // MARK: - Internal Functions
    
    internal func open(blogPost: ExampleBlogPost) {
        self.performSegue(withIdentifier: "blogPostViewController", sender: nil)
    }
}
