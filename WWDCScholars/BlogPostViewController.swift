//
//  BlogPostViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 26/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    @IBOutlet private weak var titleLabelHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var authorContainerView: UIView?
    @IBOutlet private weak var authorButton: UIButton?
    @IBOutlet private weak var webView: UIWebView?
    
    private let titleLabelHeightConstraintUpdateValue: CGFloat = 1.0
    private var scholar: BasicScholar? = nil
    
//    private let titleLabelText = "Meeting Apple Executives"
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var heroImageView: UIImageView?
    
    fileprivate var heroImageViewHeight: CGFloat = 0.0
    
    // MARK: - Private Properties
    internal var blogPost: BlogPost! = nil
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.populateHeaderContent()
        
        if let author = self.blogPost.author {
        CloudKitManager.shared.loadScholarsForBlog(with: author.recordID, recordFetched: { scholar in
            self.scholar = scholar
            scholar.profilePictureLoaded = { err in
                print (err.debugDescription)
                DispatchQueue.main.async {
                    self.populateHeaderAuthorContent()
                }
            }
        }, completion: nil)
        }
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.heroImageViewHeight = self.heroImageView?.frame.height ?? 0.0
        
        self.configureTitleLabel()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
        self.titleLabel?.applyDetailHeaderTitleStyle()
        self.authorLabel?.applyDetailContentStyle()
        
        self.authorContainerView?.roundCorners()
        self.authorContainerView?.applyRelativeCircularBorder()
        
        self.authorButton?.roundCorners()
    }
    
    private func configureUI() {
        self.heroImageView?.clipsToBounds = true
        self.webView?.scrollView.isScrollEnabled = false
        self.webView?.scrollView.bounces = false
    }
    
    private func configureTitleLabel() {
        let font = self.titleLabel?.font
        let width = self.titleLabel?.frame.width ?? 0.0
        let height = self.blogPost.title.height(for: width, font: font)
        self.titleLabelHeightConstraint?.constant = height + self.titleLabelHeightConstraintUpdateValue
    }
    
    // MARK: - Actions
    
    @IBAction internal func authorButtonTapped() {
        self.presentProfileViewController()
    }
    
    // MARK: - Private Functions
    
    private func populateHeaderAuthorContent() {
        self.authorButton?.setBackgroundImage(self.scholar?.profilePicture?.image, for: .normal)
        self.authorLabel?.text = "by \(scholar?.firstName ?? "Guest")"
    }
    
    private func populateHeaderContent() {
        let authorButtonImage = UIImage(named: "profile")
        self.authorButton?.setBackgroundImage(authorButtonImage, for: .normal)
        self.heroImageView?.image = self.blogPost.headerImage.image
        self.titleLabel?.text = self.blogPost?.title
    }
}

extension BlogPostViewController: UIScrollViewDelegate, HeaderParallaxAssist {
    
    // MARK: - Internal Functions
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateHeaderParallax(for: scrollView, on: self.heroImageView, baseHeight: self.heroImageViewHeight)
    }
}
