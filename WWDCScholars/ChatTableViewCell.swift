//
//  ChatTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 03/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 7.0
        self.circleView.applyRoundedCorners()
    }
}
