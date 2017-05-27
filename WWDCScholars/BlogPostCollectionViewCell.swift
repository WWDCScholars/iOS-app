//
//  BlogPostCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 07/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostCollectionViewCell: UICollectionViewCell, Cell {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var heroImageView: UIImageView?
    @IBOutlet private weak var authorProfileButton: UIButton?
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
        self.authorProfileButton?.roundCorners()
    }
    
    // MARK: - Internal Functions
    
    internal func configure(with cellContent: CellContent) {
        self.cellContent = cellContent
        
        guard let cellContent = cellContent as? BlogPostCollectionViewCellContent else {
            return
        }
        
        let blogPost = cellContent.blogPost
        self.heroImageView?.image = blogPost.heroImage
        self.authorProfileButton?.setBackgroundImage(blogPost.author.profileImage, for: .normal)
        self.titleLabel?.text = blogPost.title
        self.authorLabel?.text = "by \(blogPost.author.fullName)"
    }
}
