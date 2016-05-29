//
//  SocialButtonsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

protocol SocialButtonDelegate {
    func openURL(url: String)
    func composeEmail(address: String)
}

class SocialButtonsTableViewCell: UITableViewCell {
    @IBOutlet private weak var iconsView: UIView!
    @IBOutlet weak var twitterImageView: UIButton!
    @IBOutlet weak var linkedInImageView: UIButton!
    @IBOutlet weak var emailImageView: UIButton!
    @IBOutlet weak var facebookImageView: UIButton!
    @IBOutlet weak var githubImageView: UIButton!
    @IBOutlet weak var websiteImageView: UIButton!
    @IBOutlet weak var appStoreImageView: UIButton!
    
    var delegate: SocialButtonDelegate?
    var scholar: Scholar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.linkedInImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.linkedInTapped), forControlEvents: .TouchUpInside)
        self.githubImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.gitHubTapped), forControlEvents: .TouchUpInside)
        self.websiteImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.websiteTapped), forControlEvents: .TouchUpInside)
        self.emailImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.emailTapped), forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Internal functions
    
    internal func linkedInTapped() {
        self.delegate?.openURL(self.scholar.linkedInURL!)
    }
    
    internal func gitHubTapped() {
        self.delegate?.openURL(self.scholar.githubURL!)
    }
    
    internal func websiteTapped() {
        self.delegate?.openURL(self.scholar.websiteURL!)
    }
    
    internal func emailTapped() {
        self.delegate?.composeEmail(self.scholar.email)
    }
    
    // MARK: - Public functions
    
    func setIconVisibility() {
        self.linkedInImageView.hidden = self.scholar.linkedInURL == nil
        self.facebookImageView.hidden = self.scholar.facebookURL == nil
        self.githubImageView.hidden = self.scholar.githubURL == nil
        self.websiteImageView.hidden = self.scholar.websiteURL == nil
        self.appStoreImageView.hidden = self.scholar.iTunesURL == nil
        
        self.twitterImageView.hidden = true //Missing implementation
        self.emailImageView.hidden = false //Never hidden
    }
}
