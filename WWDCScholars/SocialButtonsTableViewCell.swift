//
//  SocialButtonsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class SocialButtonsTableViewCell: UITableViewCell {
    @IBOutlet private weak var iconsView: UIView!
    @IBOutlet weak var twitterImageView: UIButton!
    @IBOutlet weak var linkedInImageView: UIButton!
    @IBOutlet weak var emailImageView: UIButton!
    @IBOutlet weak var facebookImageView: UIButton!
    @IBOutlet weak var githubImageView: UIButton!
    @IBOutlet weak var websiteImageView: UIButton!
    @IBOutlet weak var appStoreImageView: UIButton!
    
    func setIconVisibility(scholar: Scholar) {
        self.linkedInImageView.hidden = scholar.linkedInURL == nil
        self.facebookImageView.hidden = scholar.facebookURL == nil
        self.githubImageView.hidden = scholar.facebookURL == nil
        self.websiteImageView.hidden = scholar.websiteURL == nil
        self.appStoreImageView.hidden = scholar.iTunesURL == nil
        
        self.twitterImageView.hidden = true //Missing implementation
        self.emailImageView.hidden = false //Never hidden
    }
}
