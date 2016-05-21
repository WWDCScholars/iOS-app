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
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var currentPost: BlogPost!
    var titleView = UIScrollView()
    var titleViewLabel = UILabel()
    var titleViewOverlayLabel = UILabel()
    
    override func viewDidLoad() {
        self.styleUI()
        self.configureUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeTitleView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addTitleView()
    }
    
    override func viewDidLayoutSubviews() {
        self.webViewDidFinishLoad(self.webView)
    }
    
    private func removeTitleView() {
        self.titleViewOverlayLabel.removeFromSuperview()
        
        if self.titleView.contentOffset.y != 44.0 {
            let contentOffset = CGPointMake(0.0, 44.0)
            
            self.titleView.contentOffset.y = contentOffset.y
            self.titleViewLabel.text = "Blog Post"
        }
    }
    
    private func addTitleView() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        let labelHeight: CGFloat = 44.0
        
        self.titleViewOverlayLabel.text = "Blog Post"
        self.titleViewOverlayLabel.textAlignment = .Center
        self.titleViewOverlayLabel.font = UIFont.boldSystemFontOfSize(17.0)
        self.titleViewOverlayLabel.textColor = UIColor.whiteColor()
        self.titleViewOverlayLabel.frame = CGRectMake(75.0, 0.0, navigationBar.frame.width - 150.0, labelHeight)
        self.navigationController?.navigationBar.addSubview(self.titleViewOverlayLabel)
        
        self.titleView = UIScrollView(frame: CGRectMake(0.0, labelHeight, navigationBar.frame.width - 200.0, labelHeight))
        self.titleView.contentSize = CGSizeMake(0.0, labelHeight * 2.0)
        self.titleView.userInteractionEnabled = false
        
        self.titleViewLabel.frame = CGRectMake(0, labelHeight, self.titleView.frame.width, labelHeight)
        self.titleViewLabel.textAlignment = .Center
        self.titleViewLabel.font = UIFont.boldSystemFontOfSize(17.0)
        self.titleViewLabel.textColor = UIColor.whiteColor()
        self.titleView.addSubview(self.titleViewLabel)
        self.navigationItem.titleView = self.titleView
        self.titleViewLabel.text = self.currentPost.title
        
        self.scrollViewDidScroll(self.scrollView)
    }
    
    private func configureUI() {
        self.titleLabel.text = self.currentPost.title
        self.authorLabel.text = self.currentPost.scholarName
        
//        var tagsString = ""
//        for (index, tag) in self.currentPost!.tags.enumerate() {
//            tagsString.appendContentsOf(index != self.currentPost!.tags.count - 1 ? "\(tag), " : tag)
//        }
//        self.tagsLabel.text = tagsString
        self.dateLabel.text = String(self.currentPost.createdAt)
        self.webView.loadHTMLString(self.currentPost.content, baseURL: nil)
        
        self.headerImageView.af_setImageWithURL(NSURL(string: self.currentPost.imageUrl)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
    }
    
    private func styleUI() {
        self.webView.scrollView.scrollEnabled = false
        self.webView.scrollView.bounces = false
        
        self.authorProfileImageView.applyRoundedCorners()
        self.authorProfileImageViewBackground.applyRoundedCorners()
    }
}

extension BlogPostDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        var frame = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        
        let fittingSize = webView.sizeThatFits(.zero)
        frame.size = fittingSize
        webView.frame = frame
        
        self.scrollView.contentSize.height = self.webView.frame.origin.y + self.webView.frame.height - 40.0
    }
}

extension BlogPostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // HeaderImageView
        
        let imageViewHeight: CGFloat = 156.0
        var imageViewFrame = CGRect(x: 0.0, y: 0.0, width: scrollView.bounds.width, height: imageViewHeight)
        
        if scrollView.contentOffset.y < imageViewHeight {
            imageViewFrame.origin.y = scrollView.contentOffset.y
            imageViewFrame.size.height = -scrollView.contentOffset.y + imageViewHeight
        }
        
        // TitleView
        
        self.headerImageView.frame = imageViewFrame
        
        let contentOffset: CGPoint = CGPointMake(0.0, min(scrollView.contentOffset.y - imageViewHeight - (self.titleLabel.frame.height / 2.0) + 22.0, 44.0))
        self.titleView.contentOffset.y = contentOffset.y
        self.titleViewOverlayLabel.alpha = -((self.titleView.contentOffset.y) / 25.0)
    }
}