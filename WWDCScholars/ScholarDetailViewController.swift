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
import AlamofireImage

enum ScreenSize: CGFloat {
    case threePointFive = 480.0
    case four = 568.0
    case fourPointSeven = 667.0
    case fivePointFive = 736.0
    
    static func forRawValue(_ float: CGFloat) -> ScreenSize {
        switch float {
        case threePointFive.rawValue:
            return .threePointFive
        case four.rawValue:
            return .four
        case fourPointSeven.rawValue:
            return .fourPointSeven
        case fivePointFive.rawValue:
            return .fivePointFive
        default:
            return .fivePointFive
        }
    }
    
    var adjustmentValue: CGFloat {
        switch self {
        case .threePointFive:
            return 47.0
        case .four:
            return 142.0
        case .fourPointSeven:
            return 128.0
        case .fivePointFive:
            return 282.0
        }
    }
}

@objc protocol QuickActionsDelegate {
    func openContactURL(_ url: String)
    func composeEmail(_ address: String)
    @objc optional func refreshScholarsWithNewFavorite()
}

class ScholarDetailViewController: UIViewController, ImageTappedDelegate, SocialButtonDelegate, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet fileprivate weak var contentSizeConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var detailsTableView: UITableView!
    @IBOutlet fileprivate weak var mapView: MKMapView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var locationLabel: UILabel!
    @IBOutlet fileprivate weak var profileImageView: UIImageView!
    @IBOutlet fileprivate weak var profileImageViewBackground: UIView!
    @IBOutlet fileprivate weak var teamIconImageView: UIImageView!
    @IBOutlet fileprivate weak var favoritesButton: UIBarButtonItem!
    
    @IBOutlet var editProfileButton: UIBarButtonItem!
    
    fileprivate var loggedInScholarString: NSString!
    fileprivate var editBarButtonItem: UIBarButtonItem!
    fileprivate var currentScholar: Scholar?
    
    var delegate: QuickActionsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ScholarDetailViewController.editProfileButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScholarDetailViewController.profileImageTapped))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        
        let mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScholarDetailViewController.convertMapToImage))
        self.mapView.isUserInteractionEnabled = true
        self.mapView.addGestureRecognizer(mapTapGestureRecognizer)
        
        self.styleUI()
        self.updateUI()
        self.editButtonVisible()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Map hotfix. Should release cached memory when leaving screen
        self.mapView.mapType = .standard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            let editVC = (segue.destination as! UINavigationController).viewControllers.first as! EditProfileTableViewController
            editVC.setScholar(self.currentScholar?.id ?? "")
        }
    }
    
    // MARK: - UIPreviewActions
    
    override var previewActionItems : [UIPreviewActionItem] {
        let indexOfFavorite = UserDefaults.favorites.index(of: self.currentScholar?.id ?? "")
        let actionTitle = indexOfFavorite == nil ? "Add to saved" : "Remove from saved"
        let actionStyle: UIPreviewActionStyle = indexOfFavorite == nil ? .default : .destructive
        
        let favoriteAction = UIPreviewAction(title: actionTitle, style: actionStyle) { (action, viewController) -> Void in
            if indexOfFavorite == nil {
                UserDefaults.favorites.append(self.currentScholar?.id ?? "")
            } else {
                UserDefaults.favorites.remove(at: indexOfFavorite!)
                
                
                let scholarDetailVC = ScholarDetailViewController()
                
                scholarDetailVC.delegate?.refreshScholarsWithNewFavorite!()
            }
        }
        
        var actions: [UIPreviewAction] = []
        
        if let websiteURL = self.currentScholar?.websiteURL {
            let websiteAction = UIPreviewAction(title: "Website", style: .default) { (action, viewController) -> Void in
                self.delegate?.openContactURL(websiteURL)
            }
            
            actions.append(websiteAction)
        }
        
        if let emailAddress = self.currentScholar?.email {
            let emailAction = UIPreviewAction(title: "Email", style: .default) { (action, viewController) -> Void in
                self.delegate?.composeEmail(emailAddress)
            }
            
            actions.append(emailAction)
        }
        
        if let linkedInURL = self.currentScholar?.linkedInURL {
            let linkedInAction = UIPreviewAction(title: "LinkedIn", style: .default) { (action, viewController) -> Void in
                self.delegate?.openContactURL(linkedInURL)
            }
            
            actions.append(linkedInAction)
        }
        
        let socialActions = UIPreviewActionGroup(title: "Contact", style: .default, actions: actions)
        
        return [socialActions, favoriteAction]
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.profileImageViewBackground.applyRoundedCorners()
        self.profileImageView.applyRoundedCorners()
        
        self.profileImageView.clipsToBounds = true

        self.detailsTableView.estimatedRowHeight = 80.0
        self.detailsTableView.setNeedsLayout()
        self.detailsTableView.layoutIfNeeded()
        
        // Fix ScrollView Constraint
        let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            let offset = self.detailsTableView.rectForRow(at: IndexPath(row: 1, section: 0)).height+self.detailsTableView.rectForRow(at: IndexPath(row: 3, section: 0)).height - self.contentSizeConstraint.constant - ScreenSize.forRawValue(UIScreen.main.bounds.height).adjustmentValue
            self.contentSizeConstraint.constant += offset
            print(offset)
        }
        
        self.configureMap()
    }
    
    // MARK: - Private functions
    
    fileprivate func editButtonVisible() {
        if UserKit.sharedInstance.isLoggedIn {
            self.loggedInScholarString = UserKit.sharedInstance.scholarId as NSString?? ?? "unknown"
            
            if self.loggedInScholarString as String == (self.currentScholar?.id)! {
                self.navigationItem.rightBarButtonItems = [self.editBarButtonItem, self.favoritesButton]
            } else {
                self.navigationItem.rightBarButtonItems = [self.favoritesButton]
            }
        } else {
            self.navigationItem.rightBarButtonItems = [self.favoritesButton]
        }
    }
    
    fileprivate func configureMap() {
        guard let scholar = self.currentScholar else {
            return
        }
        
        self.mapView.isZoomEnabled = false
        self.mapView.isScrollEnabled = false
        self.mapView.isRotateEnabled = false
        self.mapView.isPitchEnabled = false
        
        let camera = MKMapCamera()
        camera.altitude = 7500
        camera.centerCoordinate.latitude = scholar.location.latitude - 0.013
        camera.centerCoordinate.longitude = scholar.location.longitude
        
        self.mapView.setCamera(camera, animated: false)
    }
    
    fileprivate func updateUI() {
        guard let scholar = self.currentScholar else {
            return
        }
        
        self.title = scholar.fullName
        
        self.setFavoriteImage(UserDefaults.favorites.contains(scholar.id))
        self.teamIconImageView.isHidden = !CreditsManager.sharedInstance.checkForCredit(scholar)
        self.locationLabel.text = scholar.location.name
        self.nameLabel.text = scholar.firstName + " " + scholar.lastName
        self.profileImageView.af_setImage(withURL:Foundation.URL(string: scholar.latestBatch.profilePic)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false)
//        self.profileImageView.af_setImageWithURL(Foundation.URL(string: scholar.latestBatch.profilePic)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false)
    }
    
    fileprivate func setFavoriteImage(_ filled: Bool) {
        self.favoritesButton.image = UIImage(named: filled ? "favouriteFilled" : "favouriteUnfilled")
        self.favoritesButton.tintColor = filled ? UIColor.goldColor() : UIColor.white
    }
    
    // MARK: - Internal functions
    
    internal func convertMapToImage() {
        let regularSize = self.mapView.frame.size
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        self.mapView.frame.size = CGSize(width: viewWidth, height: viewHeight)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: viewWidth, height: viewHeight), false, UIScreen.main.scale)
        self.mapView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView()
        imageView.frame = self.mapView.frame
        imageView.image = image
        
        self.mapView.frame.size = regularSize
        
        self.showFullScreenImage(imageView)
    }
    
    internal func profileImageTapped() {
        self.showFullScreenImage(self.profileImageView)
    }
    
    internal func showFullScreenImage(_ imageView: UIImageView) {
        ImageManager.sharedInstance.expandImage(imageView, viewController: self)
    }
    
    func openURL(_ url: String) {
        let viewController = SFSafariViewController(url: Foundation.URL(string: url)!)
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    internal func composeEmail(_ address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    internal func setScholar(_ id: String) {
        self.currentScholar = DatabaseManager.sharedInstance.scholarForId(id)
    }
    
    // MARK: - IBActions
    
    @IBAction func favoriteButtonTapped(_ sender: AnyObject) {
        let indexOfFavorite = UserDefaults.favorites.index(of: self.currentScholar?.id ?? "")
        
        self.setFavoriteImage(indexOfFavorite == nil)
        
        if indexOfFavorite == nil {
            UserDefaults.favorites.append(self.currentScholar?.id ?? "")
        } else {
            UserDefaults.favorites.remove(at: indexOfFavorite!)
        }
        let scholarDetailVC = ScholarDetailViewController()
        
        scholarDetailVC.delegate?.refreshScholarsWithNewFavorite!()

    }
    
    @IBAction func editProfileButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "editProfile", sender: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let scholar = self.currentScholar else {
            return UITableViewCell()
        }
        
        switch indexPath.item {
        case 0:
            let cell = self.detailsTableView.dequeueReusableCell(withIdentifier: "basicDetailsTableViewCell") as! BasicDetailsTableViewCell
            
            var attendedString = ""
            for (index, batch) in scholar.batches.reversed().enumerated() {
                attendedString.append(index != scholar.batches.count - 1 ? "\(batch.batchWWDC.shortVersion), " : batch.batchWWDC.shortVersion)
            }
            
            cell.ageLabel.text = String(scholar.age)
            let locationArr = scholar.location.name.characters.split(separator: ",").map(String.init)
            cell.countryLabel.text = locationArr[locationArr.count - 1]
            cell.attendedLabel.text = attendedString
            
            return cell
        case 1:
            let cell = self.detailsTableView.dequeueReusableCell(withIdentifier: "bioTableViewCell") as! BioTableViewCell
            
            cell.contentLabel.text = scholar.shortBio
            
            return cell
        case 2:
            let cell = self.detailsTableView.dequeueReusableCell(withIdentifier: "socialButtonsTableViewCell") as! SocialButtonsTableViewCell
            
            cell.scholar = scholar
            cell.delegate = self
            cell.setIconVisibility()
            
            return cell
        case 3:
            let cell = self.detailsTableView.dequeueReusableCell(withIdentifier: "screenshotsTableViewCell") as! ScreenshotsTableViewCell
            
            cell.scholarshipScreenshots = scholar.latestBatch.screenshots
            cell.is2016 = scholar.latestBatch.appstoreSubmissionURL != nil
            cell.setAppStoreURL(scholar.latestBatch.appstoreSubmissionURL ?? "")
            cell.delegate = self
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let scholar = self.currentScholar else {
            return 0.0
        }
        
        switch indexPath.item {
        case 0:
            return 70.0
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return 54.0
        case 3:
            return scholar.latestBatch.appstoreSubmissionURL != nil ? 348.0 : 304.0
        default:
            return 0.0
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let mapHeight: CGFloat = 156.0
        var mapFrame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: mapHeight)
        
        if scrollView.contentOffset.y < mapHeight {
            mapFrame.origin.y = scrollView.contentOffset.y
            mapFrame.size.height = -scrollView.contentOffset.y + mapHeight
        }
        
        self.mapView.frame = mapFrame
    }
}
























































