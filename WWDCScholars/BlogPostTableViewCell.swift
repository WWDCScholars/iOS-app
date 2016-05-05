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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.postImageView.clipsToBounds = true
        self.postImageView.layer.masksToBounds = true
        
        self.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - Public Functions
    
    func cellOnTableView(tableView: UITableView, view: UIView) {
        let rectInSuperview = tableView.convertRect(self.frame, toView: view)
        let distanceFromCenter = CGRectGetHeight(view.frame) / 2 - CGRectGetMinY(rectInSuperview)
        let difference = (CGRectGetHeight(self.postImageView.frame) - CGRectGetHeight(self.frame)) - 40.0
        let move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference
        
        var imageRect = self.postImageView.frame
        imageRect.origin.y = (-difference / 2) - move
        self.postImageView.frame = imageRect
    }
}
