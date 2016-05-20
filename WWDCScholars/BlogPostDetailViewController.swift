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
    
    override func viewDidLoad() {
        self.styleUI()
    }
    
    private func styleUI() {
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