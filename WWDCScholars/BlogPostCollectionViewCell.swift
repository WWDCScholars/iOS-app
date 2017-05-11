//
//  BlogPostCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 07/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogPostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var heroImageView: UIImageView?
    @IBOutlet private weak var authorProfileButton: UIButton?
    @IBOutlet private weak var authorProfileContainerView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    @IBOutlet private weak var infoContainerView: UIView?
    
    // MARK: - Lifecycle
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
        self.configureUI()
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
    
    private func configureUI() {
        let authorProfileImage = UIImage(named: "profile")
        self.authorProfileButton?.setBackgroundImage(authorProfileImage, for: .normal)
        
        let heroImage = UIImage(named: "blogPostHero")
        self.heroImageView?.image = heroImage
        
        self.titleLabel?.text = "Meeting Apple Executives"
        self.authorLabel?.text = "by Andrew Walker"
    }
}
