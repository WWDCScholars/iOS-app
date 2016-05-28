//
//  ScholarDetailViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
import MessageUI

@objc protocol QuickActionsDelegate {
    func openContactURL(url: String)
    func composeEmail(address: String)
    optional func refreshScholarsWithNewFavorite()
}

class ScholarDetailViewController: UIViewController, ImageTappedDelegate, SocialButtonDelegate, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet private weak var contentSizeConstraint: NSLayoutConstraint!
    @IBOutlet private weak var detailsTableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageViewBackground: UIView!
    @IBOutlet private weak var teamIconImageView: UIImageView!
    @IBOutlet private weak var favoritesButton: UIBarButtonItem!
    
    @IBOutlet var editProfileButton: UIBarButtonItem!
    
    var loggedInScholarString: NSString!
    
    private var editBarButtonItem: UIBarButtonItem!
    private var is2016 = true //TEMP VARIABLE
    
    private var currentScholar: Scholar?
    var delegate: QuickActionsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ScholarDetailViewController.editProfileButtonTapped(_:)))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScholarDetailViewController.profileImageTapped))
        self.profileImageView.userInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        
        let mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScholarDetailViewController.convertMapToImage))
        self.mapView.userInteractionEnabled = true
        self.mapView.addGestureRecognizer(mapTapGestureRecognizer)
        
        self.styleUI()
        self.updateUI()
        self.editButtonVisible()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.contentSizeConstraint.constant = self.detailsTableView.contentSize.height - 390.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfile" {
            let editVC = (segue.destinationViewController as! UINavigationController).viewControllers.first as! EditProfileTableViewController
            
            editVC.setScholar(self.currentScholar!.id)
        }
    }
    
    // MARK: - UIPreviewActions
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let indexOfFavorite = UserDefaults.favorites.indexOf(self.currentScholar!.id)
        let actionTitle = indexOfFavorite == nil ? "Add to saved" : "Remove from saved"
        let actionStyle: UIPreviewActionStyle = indexOfFavorite == nil ? .Default : .Destructive
        
        let favoriteAction = UIPreviewAction(title: actionTitle, style: actionStyle) { (action, viewController) -> Void in
            if indexOfFavorite == nil {
                UserDefaults.favorites.append(self.currentScholar!.id)
            } else {
                UserDefaults.favorites.removeAtIndex(indexOfFavorite!)
                
                self.delegate?.refreshScholarsWithNewFavorite!()
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
    
    internal func convertMapToImage() {
        let regularSize = self.mapView.frame.size
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        self.mapView.frame.size = CGSize(width: viewWidth, height: viewHeight)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: viewWidth, height: viewHeight), false, UIScreen.mainScreen().scale)
        self.mapView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView()
        imageView.frame = self.mapView.frame
        imageView.image = image
        
        self.mapView.frame.size = regularSize
        
        self.showFullScreenImage(imageView)
    }
    
    private func configureMap() {
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.rotateEnabled = false
        self.mapView.pitchEnabled = false
        
        let camera = MKMapCamera()
        camera.altitude = 7500
        camera.centerCoordinate.latitude = self.currentScholar!.location.latitude - 0.013
        camera.centerCoordinate.longitude = self.currentScholar!.location.longitude
        
        self.mapView.setCamera(camera, animated: false)
    }
    
    private func updateUI() {
        guard let scholar = self.currentScholar else {
            return
        }
        
        self.title = scholar.fullName
        
        self.setFavoriteImage(UserDefaults.favorites.contains(self.currentScholar!.id))
        self.teamIconImageView.hidden = !CreditsManager.sharedInstance.checkForCredit(scholar)
        self.locationLabel.text = scholar.location.name
        self.nameLabel.text = scholar.firstName + " " + scholar.lastName
        self.profileImageView.af_setImageWithURL(NSURL(string: scholar.profilePicURL)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
    }
    
    private func setFavoriteImage(filled: Bool) {
        self.favoritesButton.image = UIImage(named: filled ? "favouriteFilled" : "favouriteUnfilled")
        self.favoritesButton.tintColor = filled ? UIColor.goldColor() : UIColor.whiteColor()
    }
    
    // MARK: - Internal functions
    
    internal func profileImageTapped() {
        self.showFullScreenImage(self.profileImageView)
    }
    
    internal func showFullScreenImage(imageView: UIImageView) {
        ImageManager.sharedInstance.expandImage(imageView, viewController: self)
    }
    
    func openURL(url: String) {
        let viewController = SFSafariViewController(URL: NSURL(string: url)!)
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    internal func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func composeEmail(address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    internal func setScholar(id: String) {
        self.currentScholar = DatabaseManager.sharedInstance.scholarForId(id)
    }
    
    // MARK: - IBActions
    
    @IBAction func favoriteButtonTapped(sender: AnyObject) {
        let indexOfFavorite = UserDefaults.favorites.indexOf(self.currentScholar!.id)
        
        self.setFavoriteImage(indexOfFavorite == nil)
        
        if indexOfFavorite == nil {
            UserDefaults.favorites.append(self.currentScholar!.id)
        } else {
            UserDefaults.favorites.removeAtIndex(indexOfFavorite!)
        }
        
        self.delegate?.refreshScholarsWithNewFavorite!()
    }
    
    @IBAction func editProfileButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfile", sender: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("basicDetailsTableViewCell") as! BasicDetailsTableViewCell
            
            var attendedString = ""
            for (index, batch) in self.currentScholar!.batchWWDC.enumerate() {
                attendedString.appendContentsOf(index != self.currentScholar!.batchWWDC.count - 1 ? "\(batch.shortVersion), " : batch.shortVersion)
            }
            
            cell.ageLabel.text = String(self.currentScholar!.age)
            let locationArr = self.currentScholar!.location.name.characters.split(",").map(String.init)
            cell.countryLabel.text = locationArr[locationArr.count-1]
            cell.attendedLabel.text = attendedString
            
            return cell
        case 1:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("bioTableViewCell") as! BioTableViewCell
            
            cell.contentLabel.text = self.currentScholar?.shortBio
            
            return cell
        case 2:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("screenshotsTableViewCell") as! ScreenshotsTableViewCell
            
            cell.scholarshipScreenshots = self.currentScholar!.screenshots
            cell.is2016 = self.is2016
            cell.delegate = self
                        
            return cell
        case 3:
            let cell = self.detailsTableView.dequeueReusableCellWithIdentifier("socialButtonsTableViewCell") as! SocialButtonsTableViewCell
            
            cell.scholar = self.currentScholar!
            cell.delegate = self
            cell.setIconVisibility()
            
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
            return self.is2016 ? 348.0 : 304.0
        case 3:
            return 54.0
        default:
            return 0.0
        }
    }
    
    func editButtonVisible() {
        if UserKit.sharedInstance.isLoggedIn {
            loggedInScholarString = UserKit.sharedInstance.scholarId ?? "unknown"
            
            if loggedInScholarString == currentScholar?.id {
                // Show edit button
                self.navigationItem.rightBarButtonItems = [editBarButtonItem, favoritesButton]
                print("// Show edit button")
            }else{
                // Hide edit button
                self.navigationItem.rightBarButtonItems = [favoritesButton]
                print("// Hide edit button")
            }
        }else{
            // User not logged in
            self.navigationItem.rightBarButtonItems = [favoritesButton]
            print("// User not logged in")
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