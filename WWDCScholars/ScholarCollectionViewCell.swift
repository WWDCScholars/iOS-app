//
//  ScholarCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ScholarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        self.nameLabel.applyPurpleBackgroundStyle()
        self.layer.cornerRadius = 7
    }
}
