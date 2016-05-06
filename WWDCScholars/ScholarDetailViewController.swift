//
//  ScholarDetailViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit

protocol ContactButtonDelegate {
    func openContactURL(url: String)
    func composeEmail(address: String)
}

class ScholarDetailViewController: UIViewController {
    @IBOutlet private weak var detailsTableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageViewBackground: UIView!
    @IBOutlet private weak var teamIconImageView: UIImageView!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var favouritesButton: UIBarButtonItem!
    
    var currentScholar: Scholar?
    var delegate: ContactButtonDelegate?
    
    override func viewDidLoad() {
        self.styleUI()
        self.updateUI()
    }
    
    // MARK: - UIPreviewActions
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let indexOfFavorite = UserDefaults.favorites.indexOf(self.currentScholar!.id)
        let actionTitle = indexOfFavorite == nil ? "Add to favorites" : "Remove from favorites"
        let actionStyle: UIPreviewActionStyle = indexOfFavorite == nil ? .Default : .Destructive
        
        let favoriteAction = UIPreviewAction(title: actionTitle, style: actionStyle) { (action, viewController) -> Void in
            if indexOfFavorite == nil {
                UserDefaults.favorites.append(self.currentScholar!.id)
            } else {
                UserDefaults.favorites.removeAtIndex(indexOfFavorite!)
            }
        }
        
        var actions: [UIPreviewAction] = []
        
        if let websiteURL = self.currentScholar?.websiteURL {
            let websiteAction = UIPreviewAction(title: "Website", style: .Default) { (action, viewController) -> Void in
                self.delegate?.openContactURL(websiteURL)
            }
            
            actions.append(websiteAction)
        }
        
        if let emailAddress = self.currentScholar?.email {
            let emailAction = UIPreviewAction(title: "Email", style: .Default) { (action, viewController) -> Void in
                self.delegate?.composeEmail(emailAddress)
            }
            
            actions.append(emailAction)
        }
        
        if let linkedInURL = self.currentScholar?.linkedInURL {
            let linkedInAction = UIPreviewAction(title: "LinkedIn", style: .Default) { (action, viewController) -> Void in
                self.delegate?.openContactURL(linkedInURL)
            }
            
            actions.append(linkedInAction)
        }
        
        let socialActions = UIPreviewActionGroup(title: "Contact", style: .Default, actions: actions)
        
        return [socialActions, favoriteAction]
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.profileImageViewBackground.applyRoundedCorners()
        self.profileImageView.applyRoundedCorners()
        
        self.profileImageView.clipsToBounds = true
        
        self.detailsTableView.estimatedRowHeight = 80.0
        self.detailsTableView.setNeedsLayout()
        self.detailsTableView.layoutIfNeeded()
        
        self.configureMap()
    }
    
    // MARK: - Private functions
    
    private func configureMap() {
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.rotateEnabled = false
        self.mapView.pitchEnabled = false
        
        let camera = MKMapCamera()
        camera.altitude = 7500
        camera.centerCoordinate.latitude = currentScholar!.location.latitude
        camera.centerCoordinate.longitude = currentScholar!.location.longitude
        
        self.mapView.setCamera(camera, animated: false)
    }
    
    private func updateUI() {
        guard let scholar = self.currentScholar else {
            return
        }
        
        self.title = scholar.fullName
        
        self.teamIconImageView.hidden = !CreditsManager.sharedInstance.checkForCredit(scholar)
        self.locationLabel.text = scholar.location.name
        self.nameLabel.text = scholar.firstName
        self.profileImageView.af_setImageWithURL(NSURL(string: scholar.profilePicURL)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        
        if UserDefaults.favorites.contains(self.currentScholar!.id) {
            self.favouritesButton.image = UIImage(named: "favouriteFilled")
        } else {
            self.favouritesButton.image = UIImage(named: "favouriteUnfilled")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func favoriteButtonTapped(sender: AnyObject) {
        let indexOfFavorite = UserDefaults.favorites.indexOf(self.currentScholar!.id)
        
        if indexOfFavorite == nil {
            UserDefaults.favorites.append(self.currentScholar!.id)
            self.favouritesButton.image = UIImage(named: "favouriteFilled")
        } else {
            UserDefaults.favorites.removeAtIndex(indexOfFavorite!)
            self.favouritesButton.image = UIImage(named: "favouriteUnfilled")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("basicDetailsTableViewCell") as! BasicDetailsTableViewCell
            
            var attendedString = ""
            for (index, batch) in currentScholar!.batchWWDC.enumerate() {
                attendedString.appendContentsOf(index != currentScholar!.batchWWDC.count - 1 ? "\(batch.shortVersion), " : batch.shortVersion)
            }
            
            cell.ageLabel.text = String(currentScholar!.age)
            let locationArr = currentScholar!.location.name.characters.split(",").map(String.init)
            cell.countryLabel.text = locationArr[locationArr.count-1]
            cell.attendedLabel.text = attendedString
            
            return cell
        case 1:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("bioTableViewCell") as! BioTableViewCell
            
            cell.contentLabel.text = currentScholar?.shortBio
            
            return cell
        case 2:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("screenshotsTableViewCell") as! ScreenshotsTableViewCell
                        
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            return 70.0
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return 296.0
        default:
            return 0.0
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let mapHeight: CGFloat = 156.0
        var mapFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: mapHeight)
        
        if scrollView.contentOffset.y < mapHeight {
            mapFrame.origin.y = scrollView.contentOffset.y
            mapFrame.size.height = -scrollView.contentOffset.y + mapHeight
        }
        
        self.mapView.frame = mapFrame
    }
}