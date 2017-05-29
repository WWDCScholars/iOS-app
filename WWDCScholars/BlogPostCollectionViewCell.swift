//
//  BlogPostCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 07/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostCollectionViewCell: UICollectionViewCell, Cell {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var heroImageView: UIImageView?
    @IBOutlet private weak var authorProfileImageView: UIImageView?
    @IBOutlet private weak var authorProfileContainerView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    @IBOutlet private weak var infoContainerView: UIView?
    
    // MARK: - Internal Properties
    
    internal var cellContent: CellContent?
    
    // MARK: - Lifecycle
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.applyDefaultCornerRadius()
        self.infoContainerView?.applyThumbnailFooterStyle()
        self.titleLabel?.applyBlogPostInfoTitleStyle()
        self.authorLabel?.applyBlogPostInfoAuthorStyle()
        self.authorProfileContainerView?.roundCorners()
        self.authorProfileContainerView?.applyRelativeCircularBorder()
        self.authorProfileImageView?.roundCorners()
    }
    
    // MARK: - Internal Functions
    
    internal func configure(with cellContent: CellContent) {
        self.cellContent = cellContent
        
        guard let cellContent = cellContent as? BlogPostCollectionViewCellContent else {
            return
        }
        
        let blogPost = cellContent.blogPost
        self.heroImageView?.image = blogPost.heroImage
        self.authorProfileImageView?.image = blogPost.author.profileImage
        self.titleLabel?.text = blogPost.title
        self.authorLabel?.text = "by \(blogPost.author.fullName)"
    }
}
