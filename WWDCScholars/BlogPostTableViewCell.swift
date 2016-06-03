//
//  BlogPostTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 05/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class BlogPostTableViewCell: UITableViewCell {
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDetailsContainerView: UIView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.postDetailsContainerView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurEffectView.alpha = 0.75
        
        self.postDetailsContainerView.addSubview(blurEffectView)
        self.postDetailsContainerView.bringSubviewToFront(self.postTitleLabel)
        self.postDetailsContainerView.bringSubviewToFront(self.detailsStackView)
        
        self.postDateLabel.textColor = UIColor.mediumWhiteTextColor()
    }
    
    // MARK: - Public Functions
    
    func cellOnTableView(tableView: UITableView, view: UIView) {
        let rectInSuperview = tableView.convertRect(self.frame, toView: view)
        let distanceFromCenter = CGRectGetHeight(view.frame) / 2 - CGRectGetMinY(rectInSuperview)
        let difference = (CGRectGetHeight(self.postImageView.frame) - CGRectGetHeight(self.frame))
        let move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference
        
        var imageRect = self.postImageView.frame
        imageRect.origin.y = (-difference / 2) - move
        self.postImageView.frame = imageRect
    }
}
