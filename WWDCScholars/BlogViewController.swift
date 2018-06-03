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
    private var blogPosts: [BlogPost] = []
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView?
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.configureBlogPostContentController()
        self.loadBlogPosts()
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
            if !self.blogPosts.contains(where: { blogPost.id == $0.id }) {
                self.blogPosts.append(blogPost)
            }
        }, completion: { _, error in
            guard error == nil else {
                //todo: error handling
                print (error.debugDescription)
                return
            }
        
            
            let blogPostSectionContent = BlogViewControllerCellContentFactory.blogPostSectionContent(from: self.blogPosts, delegate: self)
            self.blogPostCollectionViewContentController.add(sectionContent: blogPostSectionContent)

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
        self.performSegue(withIdentifier: "blogPostViewController", sender: blogPost)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "blogPostViewController" {
            let dest = segue.destination as! BlogPostViewController
            dest.blogPost = sender as? BlogPost
        }
    }
}
