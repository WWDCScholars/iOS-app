//
//  ProfileViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 16/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import DeckTransition
import CloudKit
import CoreLocation

internal final class ProfileViewController: UIViewController {
    
    // MARK: - Internal Properties
    internal var scholarId: CKRecordID? = nil
    
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
    
    private var scholar: Scholar? = nil
    private var batch: Batch? = nil
    
    private var profileSocialAccountsFactory: ProfileSocialAccountsFactory?
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var mapView: MKMapView?
    
    fileprivate var mapViewHeight: CGFloat = 0.0
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = scholarId else {
            print ("ScholarID is nil")
            return
        }
        
        self.styleUI()
        self.configureUI()
        self.loadScholarData()
        
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.mapViewHeight = self.mapView?.frame.height ?? 0.0
        
        self.configureBioLabel()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
        
        self.nameLabel?.applyDetailHeaderTitleStyle()
        self.locationLabel?.applyDetailContentStyle()
        self.ageTitleLabel?.applyDetailTitleStyle()
        self.ageContentLabel?.applyDetailContentStyle()
        self.countryTitleLabel?.applyDetailTitleStyle()
        self.countryContentLabel?.applyDetailContentStyle()
        self.batchTitleLabel?.applyDetailTitleStyle()
        self.batchContentLabel?.applyDetailContentStyle()
        self.bioLabel?.applyDetailContentStyle()
        
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
        let height = self.scholar?.shortBio.height(for: width, font: font) ?? 0
        self.bioLabelHeightConstraint?.constant = height + self.bioLabelHeightConstraintUpdateValue
    }
    
    // MARK: - Private Functions
    
    private func loadScholarData() {
        CloudKitManager.shared.loadScholar(with: scholarId!, recordFetched: { scholar in
            self.scholar = scholar
            CloudKitManager.shared.loadSocialMedia(with: scholar.socialMediaRef.recordID, recordFetched: { socialMedia in
                self.profileSocialAccountsFactory = ProfileSocialAccountsFactory(socialMedia: socialMedia)
                DispatchQueue.main.async {
                    self.populateSocialAccountsContent()
                }
            }, completion: nil)
            
            DispatchQueue.main.async {
                self.populateHeaderContent()
                self.populateBasicInfoContent()
                self.populateBioContent()
                self.configureMapView()
            }
            
        }, completion: { _, err in
            print ("\(err.debugDescription)")
        })
    }
    
    private func configureMapView() {
        guard let scholar = scholar else {
            return
        }
        
        self.mapView?.setCenter(scholar.location.coordinate, animated: true)
    }
    
    private func populateHeaderContent() {
        guard let scholar = scholar else {
            return
        }
        
        self.profilePictureImageView?.image = UIImage(named: "profile")
        self.nameLabel?.text = scholar.fullName
        
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(scholar.location, completionHandler: { placemarks,err in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            let city = placeMark.addressDictionary?["City"] as? String ?? ""
            
            let country = placeMark.addressDictionary?["Country"] as? String ?? ""
            
            DispatchQueue.main.async {
                self.locationLabel?.text = "\(city), \(country)"
                self.countryContentLabel?.text = country
            }
        })
    }
    
    private func populateBasicInfoContent() {
        guard let scholar = scholar else {
            return
        }
        
        self.ageTitleLabel?.text = "Age"
        self.ageContentLabel?.text = "\(scholar.birthday.age)"
        self.countryTitleLabel?.text = "Country"
        self.batchTitleLabel?.text = "Attended"
        self.batchContentLabel?.text = scholar.batches.joined(separator: ", ")
    }
    
    private func populateBioContent() {
        guard let scholar = scholar else {
            return
        }
        
        self.bioLabel?.text = scholar.shortBio
    }
    
    private func populateSocialAccountsContent() {
        let socialAccountButtons = self.profileSocialAccountsFactory?.accountButtons() ?? []
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
