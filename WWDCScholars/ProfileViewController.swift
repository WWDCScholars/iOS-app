//
//  ProfileViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 16/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import DeckTransition

internal final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var profilePictureImageView: UIImageView?
    @IBOutlet private weak var profilePictureContainerView: UIView?
    @IBOutlet private weak var teamImageView: UIImageView?
    @IBOutlet private weak var teamContainerView: UIView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var locationLabel: UILabel?
    @IBOutlet private weak var ageTitleLabel: UILabel?
    @IBOutlet private weak var ageContentLabel: UILabel?
    @IBOutlet private weak var countryTitleLabel: UILabel?
    @IBOutlet private weak var countryContentLabel: UILabel?
    @IBOutlet private weak var batchTitleLabel: UILabel?
    @IBOutlet private weak var batchContentLabel: UILabel?
    @IBOutlet private weak var bioLabel: UILabel?
    @IBOutlet private weak var bioLabelHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var socialAccountsStackView: UIStackView?
    
    private let bioLabelHeightConstraintUpdateValue: CGFloat = 1.0
    private let bioLabelText = "I’m a 20 year old App Developer from Edinburgh, UK currently studying Computing Engineering at Edinburgh Napier University. I have developed more than 15 iOS apps since I began in summer 2014. My main interests are technology, guitar, aviation and design."
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var mapView: MKMapView?
    
    fileprivate var mapViewHeight: CGFloat = 0.0
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.populateHeaderContent()
        self.populateBasicInfoContent()
        self.populateBioContent()
        self.populateSocialAccountsContent()
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.mapViewHeight = self.mapView?.frame.height ?? 0.0
        
        self.configureBioLabel()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
        
        self.nameLabel?.applyProfileNameStyle()
        self.locationLabel?.applyProfileContentStyle()
        self.ageTitleLabel?.applyProfileTitleStyle()
        self.ageContentLabel?.applyProfileContentStyle()
        self.countryTitleLabel?.applyProfileTitleStyle()
        self.countryContentLabel?.applyProfileContentStyle()
        self.batchTitleLabel?.applyProfileTitleStyle()
        self.batchContentLabel?.applyProfileContentStyle()
        self.bioLabel?.applyProfileContentStyle()
        
        self.profilePictureContainerView?.roundCorners()
        self.profilePictureContainerView?.applyRelativeCircularBorder()
        self.teamContainerView?.roundCorners()
        self.teamContainerView?.applyRelativeCircularBorder()
        
        self.teamImageView?.roundCorners()
        self.profilePictureImageView?.roundCorners()
    }
    
    private func configureUI() {
        self.title = "Profile"
        
        self.mapView?.isUserInteractionEnabled = false
    }
    
    private func configureBioLabel() {
        let font = self.bioLabel?.font
        let width = self.bioLabel?.frame.width ?? 0.0
        let height = self.bioLabelText.height(for: width, font: font)
        self.bioLabelHeightConstraint?.constant = height + self.bioLabelHeightConstraintUpdateValue
    }
    
    // MARK: - Private Functions
    
    private func populateHeaderContent() {
        self.profilePictureImageView?.image = UIImage(named: "profile")
        self.nameLabel?.text = "Andrew Walker"
        self.locationLabel?.text = "Edinburgh, UK"
    }
    
    private func populateBasicInfoContent() {
        self.ageTitleLabel?.text = "Age"
        self.ageContentLabel?.text = "20"
        self.countryTitleLabel?.text = "Country"
        self.countryContentLabel?.text = "UK"
        self.batchTitleLabel?.text = "Attended"
        self.batchContentLabel?.text = "'15, '16, '17"
    }
    
    private func populateBioContent() {
        self.bioLabel?.text = self.bioLabelText
    }
    
    private func populateSocialAccountsContent() {
        let socialAccountButtons = ProfileSocialAccountsFactory.accountButtons()
        for button in socialAccountButtons {
            self.socialAccountsStackView?.addArrangedSubview(button)
        }
    }
}

extension ProfileViewController: UIScrollViewDelegate, DeckTransitionScrollAssist, HeaderParallaxAssist {
    
    // MARK: - Internal Functions
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateDeckTransition(for: scrollView)
        self.updateHeaderParallax(for: scrollView, on: self.mapView, baseHeight: self.mapViewHeight)
    }
}
