//
//  BlogPostDetailViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 19.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class BlogPostDetailViewController: UIViewController {
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var authorProfileImageView: UIImageView!
    @IBOutlet private weak var authorProfileImageViewBackground: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var webView: UIWebView!
    
    var currentPost: BlogPost!
    
    override func viewDidLoad() {
        self.styleUI()
        self.configureUI()
    }
    
    private func configureUI() {
        self.titleLabel.text = self.currentPost.title
        self.authorLabel.text = self.currentPost.scholarName
        
        var tagsString = ""
        for (index, tag) in self.currentPost!.tags.enumerate() {
            tagsString.appendContentsOf(index != self.currentPost!.tags.count - 1 ? "\(tag), " : tag)
        }
        self.tagsLabel.text = tagsString
        self.dateLabel.text = String(self.currentPost.createdAt)
        self.webView.loadHTMLString(self.currentPost.content, baseURL: nil)
    }
    
    private func styleUI() {
        self.title = "Blog Post"
        
        self.authorProfileImageView.applyRoundedCorners()
        self.authorProfileImageViewBackground.applyRoundedCorners()
    }
}

extension BlogPostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        
        let imageViewHeight: CGFloat = 156.0
        var imageViewFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: imageViewHeight)
        
        if scrollView.contentOffset.y < imageViewHeight {
            imageViewFrame.origin.y = scrollView.contentOffset.y
            imageViewFrame.size.height = -scrollView.contentOffset.y + imageViewHeight
        }
        
        self.headerImageView.frame = imageViewFrame
    }
}