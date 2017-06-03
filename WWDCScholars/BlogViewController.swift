//
//  BlogViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let blogPostCollectionViewContentController = CollectionViewContentController()
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView?
        
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
    
    private func loadBlogPosts() {
        CloudKitManager.shared.loadBlogPosts(cursor: nil, recordFetched: { blogPost in
            let blogPostSectionContent = BlogViewControllerCellContentFactory.blogPostSectionContent(from: [blogPost], delegate: self)
            
            self.blogPostCollectionViewContentController.add(sectionContent: blogPostSectionContent)
        }, completion: { _, error in
            guard error == nil else {
                //todo: error handling
                print (error.debugDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.blogPostCollectionViewContentController.reloadContent()
            }
        })
    }
    
    private func configureBlogPostContentController() {
        self.blogPostCollectionViewContentController.configure(collectionView: self.collectionView)
    }
}

extension BlogViewController: BlogPostCollectionViewCellContentDelegate {
    
    // MARK: - Internal Functions
    
    internal func open(blogPost: BlogPost) {
        self.performSegue(withIdentifier: "blogPostViewController", sender: nil)
    }
}
