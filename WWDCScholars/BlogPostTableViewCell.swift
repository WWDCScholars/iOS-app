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
    
    fileprivate func styleUI() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.postDetailsContainerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.75
        
        self.postDetailsContainerView.addSubview(blurEffectView)
        self.postDetailsContainerView.bringSubview(toFront: self.postTitleLabel)
        self.postDetailsContainerView.bringSubview(toFront: self.detailsStackView)
        
        self.postDateLabel.textColor = UIColor.mediumWhiteTextColor()
    }
    
    // MARK: - Public Functions
    
    func cellOnTableView(_ tableView: UITableView, view: UIView) {
        let rectInSuperview = tableView.convert(self.frame, to: view)
        let distanceFromCenter = view.frame.height / 2 - rectInSuperview.minY
        let difference = (self.postImageView.frame.height - self.frame.height)
        let move = (distanceFromCenter / view.frame.height) * difference
        
        var imageRect = self.postImageView.frame
        imageRect.origin.y = (-difference / 2) - move
        self.postImageView.frame = imageRect
    }
}
