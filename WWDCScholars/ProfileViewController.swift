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
import CoreLocation
import SafariServices
import MessageUI
import Nuke
import CloudKit
import Agrume

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    var scholarId: CKRecord.ID? = nil
    
    // MARK: - Private Properties
    @IBOutlet private weak var profilePictureImageView: UIImageView!
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
    @IBOutlet private weak var savedButton: UIButton!
    @IBOutlet var handleView: UIView!

    private let bioLabelHeightConstraintUpdateValue: CGFloat = 1.0
    
    private var scholar: Scholar? = nil
    private var batch: WWDCYearInfo? = nil
    private var profileSocialAccountsFactory: ProfileSocialAccountsFactory?
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var mapView: MKMapView?
    
    fileprivate var mapViewHeight: CGFloat = 0.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = scholarId else {
            print ("ScholarID is nil")
            return
        }
        
        styleUI()
        configureUI()
        loadScholarData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapViewHeight = mapView?.frame.height ?? 0.0
        
        configureBioLabel()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        view.applyBackgroundStyle()
        
        nameLabel?.applyDetailHeaderTitleStyle()
        locationLabel?.applyDetailContentStyle()
        ageTitleLabel?.applyDetailTitleStyle()
        ageContentLabel?.applyDetailContentStyle()
        countryTitleLabel?.applyDetailTitleStyle()
        countryContentLabel?.applyDetailContentStyle()
        batchTitleLabel?.applyDetailTitleStyle()
        batchContentLabel?.applyDetailContentStyle()
        bioLabel?.applyDetailContentStyle()
        
        profilePictureContainerView?.roundCorners()
        teamContainerView?.roundCorners()
        
        teamImageView?.roundCorners()
        
        profilePictureImageView?.roundCorners()
        
        profilePictureImageView?.tintColor = .backgroundElementGray
        profilePictureImageView?.contentMode = .center
        
        savedButton.setImage(UIImage(named: "Saved")?.tinted(with: .scholarsPurple), for: .normal)

        if #available(iOS 13.0, *) {
            handleView.backgroundColor = .systemGray2
        }
        handleView.roundCorners()
    }
    
    private func configureUI() {
        title = "Profile"
        
        mapView?.isUserInteractionEnabled = false
        countryTitleLabel?.text = "Country"
        batchTitleLabel?.text = "Attended"
        ageTitleLabel?.text = "Age"

        nameLabel?.text = ""
        locationLabel?.text = ""
        ageContentLabel?.text = ""
        countryContentLabel?.text = ""
        batchContentLabel?.text = ""
        bioLabel?.text = ""
        
        profilePictureImageView?.image = UIImage.loading
        
        configureTeamImageView()

        if #available(iOS 13.0, *) {
            navigationController?.isNavigationBarHidden = true
        } else {
            handleView.isHidden = true
        }
    }
    
    private func configureTeamImageView(){
        if scholar?.fullName == "Sam Eckert" ||
            scholar?.fullName == "Moritz Sternemann" ||
            scholar?.fullName == "Andrew Walker" ||
            scholar?.fullName == "Matthijs Logemann" {
            teamContainerView?.isHidden = false
        }else{
            teamContainerView?.isHidden = true
        }
    }
    
    private func configureBioLabel() {
        let font = bioLabel?.font
        let width = bioLabel?.frame.width ?? 0.0
        let height = scholar?.biography?.height(for: width, font: font) ?? 0
        bioLabelHeightConstraint?.constant = height + bioLabelHeightConstraintUpdateValue
    }
    
    @IBAction func profilePicturePressed(_ sender: Any) {
        let agrume = Agrume(image: (profilePictureImageView?.image!)!)
        agrume.show(from: self)
    }
    
    @IBAction func savedButtonPressed(_ sender: Any) {
        
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - Private Functions
    
    private func loadScholarData() {
        DispatchQueue.init(label: "ScholarLoading").async {
            self.scholar = CKDataController.shared.scholar(for: self.scholarId!)
            
            DispatchQueue.main.async {
                self.populateHeaderContent()
                self.populateBasicInfoContent()
                self.populateBioContent()
                self.configureMapView()
                
                if let profileURL = self.scholar?.profilePicture?.fileURL{
                    Nuke.loadImage(with: profileURL, into: self.profilePictureImageView!)
                }
 
                self.profilePictureImageView?.contentMode = .scaleAspectFill
                
                if let socialMedia = self.scholar?.socialMedia?.recordID{
                    print("socialMedia is \(socialMedia)")
                    
                    CloudKitManager.shared.loadSocialMedia(with: socialMedia, recordFetched: { socialMedia in
                        self.profileSocialAccountsFactory = ProfileSocialAccountsFactory(socialMedia: socialMedia)
                        DispatchQueue.main.async {
                            self.populateSocialAccountsContent()
                        }
                    }, completion: nil)
                }else{
                    print("No socialMediaID")
                }
            }
        }
    }
    
    private func configureMapView() {
        guard let scholar = scholar else {
            return
        }
        
        mapView?.setCenter(scholar.location.coordinate, animated: false)
    }
    
    private func populateHeaderContent() {
        guard let scholar = scholar else {
            return
        }
        
        nameLabel?.text = scholar.fullName
        
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(scholar.location, completionHandler: { placemarks,err in
            //todo: error handling?
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            let city = placeMark.locality ?? ""
            
            let country = placeMark.country ?? ""
            
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
        
        ageContentLabel?.text = "\(scholar.birthday?.age ?? 18)"
        
        var years = [String]()
        for yearInfo in scholar.wwdcYears ?? []{
            years.append(yearInfo.recordID.recordName)
        }
        
        batchContentLabel?.text = years.map { (string) -> String in
            let year = String(string.split(separator: " ").last ?? "")
            return "'" + String(year[2...])
        }.joined(separator: ", ")
        
    }
    
    private func populateBioContent() {
        guard let scholar = scholar else {
            return
        }
        
        bioLabel?.text = scholar.biography
    }
    
    private func populateSocialAccountsContent() {
        print("populateSocialAccountsContent")
        let socialAccountButtons = profileSocialAccountsFactory?.accountButtons() ?? []
        for button in socialAccountButtons {
            socialAccountsStackView?.addArrangedSubview(button)
			button.addTarget(self, action: #selector(openURL), for: .touchUpInside)
        }
    }
	
    @objc private func openURL(_ sender: SocialAccountButton){
        guard let urlString = sender.accountDetail else { return }
        guard let type = sender.type else { return }
        
        var vc: UIViewController?
        
        switch(type){
        case .imessage:
            let mvc = MFMessageComposeViewController()
            mvc.recipients = [urlString]
            mvc.messageComposeDelegate = self
            vc = mvc
        case .discord:
            let alert = UIAlertController(title: "Discord", message: urlString, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { action in
                UIPasteboard.general.string = urlString
            }))
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            
            present(alert, animated: true)
        default:
            guard let url = URL(string: urlString) else { return }
            vc = SFSafariViewController(url: url)
        }
        
        if let vc = vc {
            //TODO: change status bar colour when opening urls!
            present(vc, animated: true, completion: nil)
        }
	}
}

extension ProfileViewController: MFMessageComposeViewControllerDelegate {
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		dismiss(animated: true, completion: nil)
	}
}
