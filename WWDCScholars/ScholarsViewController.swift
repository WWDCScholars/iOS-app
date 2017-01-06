//
//  ViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 27.02.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SafariServices
import MessageUI
import AlamofireImage

enum CurrentViewType {
    case list
    case map
}

class ScholarsViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, QuickActionsDelegate, EditDetailsDelegate {
    @IBOutlet fileprivate weak var loadingContainerView: UIView!
    @IBOutlet fileprivate weak var yearCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var scholarsCollectionView: NoJumpRefreshCollectionView!
    @IBOutlet fileprivate weak var extendedNavigationContainer: UIView!
    @IBOutlet fileprivate weak var mainView: UIView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var mapView: MKMapView!
    @IBOutlet fileprivate weak var loginBarButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var mapBarButtonItem: UIBarButtonItem!
    
    fileprivate let years: [WWDC] = [.WWDCEarlier, .WWDC2012, .WWDC2013, .WWDC2014, .WWDC2015, .WWDC2016, .Saved]
    fileprivate let locationManager = CLLocationManager()
    fileprivate let noContentLabel = UILabel()
    fileprivate var appDelegate = UIApplication.shared.delegate as! AppDelegate

    fileprivate lazy var qTree = QTree()
    
    fileprivate var currentYear: WWDC = .WWDC2016
    fileprivate var currentScholars: [Scholar] = []
    fileprivate var searchResults = NSArray()
    fileprivate var loadingViewController: LoadingViewController!
    fileprivate var searchBarActive = false
    fileprivate var loggedIn: Bool!
    fileprivate var isMapInitalized = false
    fileprivate var myLocation: CLLocationCoordinate2D?
    fileprivate var currentViewType: CurrentViewType = .list
    fileprivate var searchText = ""
    fileprivate var selectedYearRow: IndexPath?
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var registeredPeekView: UIViewControllerPreviewing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.configureUI()
        self.styleUI()
        self.loadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.appDelegate.year = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ScholarDetailViewController()) {
            let destinationViewController = segue.destination as! ScholarDetailViewController
            destinationViewController.delegate = self
            
            if let indexPath = sender as? IndexPath {
                destinationViewController.setScholar(self.searchBarActive ? (self.searchResults[indexPath.item] as! Scholar).id : self.currentScholars[indexPath.item].id)
            } else if let scholarID = sender as? String {
                destinationViewController.setScholar(scholarID)
            }
        } else if segue.identifier == String(describing: LoadingViewController()) {
            self.loadingViewController = segue.destination as! LoadingViewController
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
  
        if self.appDelegate.year == "saved" {
            self.currentYear = years[self.years.count - 1]
        } else {
            self.currentYear = years[self.years.count - 2]
        }
        
        let index = self.years.index(of: self.currentYear)!
        self.selectedYearRow = IndexPath(item: index, section: 0)
        self.scrollCollectionViewToIndexPath(index, animated: false)
        
        self.refreshControl.superview?.sendSubview(toBack: self.refreshControl)
    }
    
    func openScholarDetail(_ id: String) {
        self.performSegue(withIdentifier: String(describing: ScholarDetailViewController()), sender: id)
    }
    
    func changeYear(_ indexPath: IndexPath) {
        self.collectionView(self.yearCollectionView, didSelectItemAt: indexPath)
    }
    
    // MARK: - UI
    
    fileprivate func configureUI() {
        self.scholarsCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        
        self.loadingContainerView.isHidden = false
        self.loadingViewController.loadingMessage = "Loading Scholars..."
        self.loadingViewController.startAnimating()
        
        if self.traitCollection.forceTouchCapability == .available {
            self.registeredPeekView = self.registerForPreviewing(with: self, sourceView: self.view)
        }
        
        let frame = self.view.frame
        self.noContentLabel.text = "Looks like there are no Scholars here yet!"
        self.noContentLabel.frame = CGRect(x: frame.origin.x + 16.0, y: -100.0, width: frame.width - 32.0, height: frame.height)
        self.noContentLabel.textColor = UIColor.mediumBlackTextColor()
        self.noContentLabel.numberOfLines = 0
        self.noContentLabel.textAlignment = .center
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.bounds = CGRect(x: self.refreshControl.bounds.origin.x + 4.0, y: -40.0, width: self.refreshControl.bounds.size.width, height: self.refreshControl.bounds.size.height)
        self.refreshControl.addTarget(self, action: #selector(ScholarsViewController.loadData), for: .valueChanged)
        self.scholarsCollectionView.addSubview(self.refreshControl)
    }
    
    fileprivate func styleUI() {
        self.title = "Scholars"
        
        self.searchBar.tintColor = UIColor.scholarsPurpleColor()
        self.extendedNavigationContainer.applyExtendedNavigationBarContainerStyle()
        self.applyExtendedNavigationBarStyle()
    }
    
    fileprivate func configureMap() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
        }
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 10000000.0, 10000000.0)
        self.mapView.setRegion(zoomRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        
        let locateButton = UIButton(type: .custom)
        locateButton.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: UIScreen.main.bounds.height - 210, width: 33, height: 33)
        locateButton.setImage(UIImage(named: "locationButton"), for: UIControlState())
        locateButton.addTarget(self, action: #selector(ScholarsViewController.locateButtonAction), for: .touchUpInside)
        locateButton.layer.shadowOpacity = 0.5
        locateButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        locateButton.layer.shadowRadius = 2.0
        locateButton.applyRoundedCorners()
        locateButton.backgroundColor = UIColor.scholarsPurpleColor()
        
        self.mapView.addSubview(locateButton)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBActions
    
    @IBAction func accountButtonTapped(_ sender: AnyObject) {
        UserKit.sharedInstance.isLoggedIn ? self.showAccountAlertController() : self.showSignInModal()
    }
    
    @IBAction func mapButtonTapped(_ sender: AnyObject) {
        if !self.isMapInitalized {
            self.configureMap()
            self.isMapInitalized = true
        }
        
        self.switchView()
    }
    
    // MARK: - Private functions
    
    fileprivate func reloadScholarsCollectionViewWithAnimation() {
        UIView.transition(with: self.scholarsCollectionView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.scholarsCollectionView.reloadData()
            }, completion: nil)
    }
    
    fileprivate func cancelSearching(_ setOffset: Bool = false) {
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
        
        self.reloadScholarsCollectionViewWithAnimation()
    }
    
    fileprivate func filterContentForSearchText() {
        let resultPredicate = NSPredicate(format: "fullName contains[cd] %@", self.searchText)
        self.searchResults = (self.currentScholars as NSArray).filtered(using: resultPredicate) as NSArray
        
        self.scholarsCollectionView.reloadData()
    }
    
    fileprivate func switchView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.mapBarButtonItem.image = UIImage(named: self.currentViewType == . list ? "gridIcon" : "mapIcon")
            self.mainView.alpha = self.currentViewType == .list ? 0.0 : 1.0
            self.mapView.alpha = self.currentViewType == .map ? 0.0 : 1.0
        })
        
        self.currentViewType = self.currentViewType == .list ? .map : .list
//        if self.currentViewType == .List && isMapInitalized {
//            self.mapView.removeFromSuperview()
//            self.mapView = nil
//            isMapInitalized = false
//        }
        
        switch self.currentViewType {
        case .list:
			if self.traitCollection.forceTouchCapability == .available {
				self.registeredPeekView = self.registerForPreviewing(with: self, sourceView: self.view)
			}
        case .map:
			// Connor, 06/05/2016 - Trying to unregister on non-3dtouch-enabled 
			// devices would crash since this would never have been set.
			if let peekView = self.registeredPeekView {
				self.unregisterForPreviewing(withContext: peekView)
			}
			
			self.registeredPeekView = nil
        }
        
        self.cancelSearching()
    }
    
    fileprivate func getCurrentScholars() {
        self.currentScholars = self.currentYear == .Saved ? self.getFavorites() : DatabaseManager.sharedInstance.scholarsForWWDCBatch(self.currentYear)
        
        if self.searchBarActive {
            self.filterContentForSearchText()
        } else {
            self.reloadScholarsCollectionViewWithAnimation()
        }
        
        if self.currentScholars.count == 0 && !self.noContentLabel.isDescendant(of: self.scholarsCollectionView) {
            self.scholarsCollectionView.addSubview(self.noContentLabel)
        } else if self.currentScholars.count > 0 {
            self.noContentLabel.removeFromSuperview()
        }
        
        self.addScholarToQTree()
        if (self.refreshControl.isRefreshing){
            self.refreshControl.endRefreshing()
        }
    }
    
    fileprivate func getFavorites() -> [Scholar] {
        var favorites: [Scholar] = []
        
        for scholarID in UserDefaults.favorites {
            if let scholar = DatabaseManager.sharedInstance.scholarForId(scholarID) {
                favorites.append(scholar)
            }
        }
        
        return favorites
    }
    
    fileprivate func addScholarToQTree() {
        self.qTree.cleanup()
        
        for scholar in self.currentScholars {
            let location = scholar.location
            let annotation = ScholarAnnotation(coordinate: CLLocationCoordinate2DMake(location.latitude, location.longitude), title: scholar.fullName, subtitle: location.name, id: scholar.id)
            self.qTree.insertObject(annotation)
        }
        
        self.reloadAnnotations()
    }
    
    fileprivate func scrollCollectionViewToIndexPath(_ index: Int, animated: Bool) {
        self.yearCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    fileprivate func showSignInModal() {
        let storyboard = UIStoryboard(name: "EditDetails", bundle: nil)
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.view.window?.rootViewController?.view.window?.rootViewController!.present(modalViewController, animated: true, completion: nil)
    }
    
    fileprivate func showAccountAlertController(){
        let storyboard = UIStoryboard(name: "EditDetails", bundle: nil)
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "SignedInVC") as! SignedInViewController
        
        modalViewController.delegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.view.window?.rootViewController?.view.window?.rootViewController!.present(modalViewController, animated: true, completion: nil)
    }
    
    // MARK: - Internal functions
    
    internal func presentEditDetailsViewController() {
        let storyboard = UIStoryboard(name: "EditDetails", bundle: nil)
        let modalViewController = storyboard.instantiateViewController(withIdentifier: "EditDetailsNC")
        
        modalViewController.modalPresentationStyle = .fullScreen
        modalViewController.modalTransitionStyle = .coverVertical
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    internal func loadData() {
        ScholarsKit.sharedInstance.loadScholars({
            if self.loadingViewController.isAnimating() {
                self.loadingContainerView.isHidden = true
                self.loadingViewController.stopAnimating()
            }
            
        // TODO: Next version add CoreSpotlight back
            
        /* for (index, scholar) in DatabaseManager.sharedInstance.getAllScholars().enumerate() {
        	SpotlightManager.sharedInstance.indexScholar(scholar, atIndex: index)
        } */
            
            
            self.getCurrentScholars()
        })
        
        if ScholarsKit.sharedInstance.hasScholars() {
            if self.loadingViewController.isAnimating() {
                self.loadingContainerView.isHidden = true
                self.loadingViewController.stopAnimating()
            }
            
            self.getCurrentScholars()
        }
        
    }
    
    internal func refreshScholarsWithNewFavorite() {
        //let scholarDetailVC = ScholarDetailViewController()
        
       // scholarDetailVC.delegate?.refreshScholarsWithNewFavorite!()

        self.getCurrentScholars()
    }
    
    internal func openContactURL(_ url: String) {
        let viewController = SFSafariViewController(url: Foundation.URL(string: url)!)
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
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
    
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    internal func locateButtonAction(_ sender: UIButton!) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let controller = UIAlertController(title: "Enable Location Services", message: "To view your current location, please first enable location services. This can be done from within your device's settings.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                controller.addAction(cancelAction)
                
                let jumpToSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                    let settingsUrl = Foundation.URL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                controller.addAction(jumpToSettingsAction)
                
                self.present(controller, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                let myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
                let zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 5000000, 5000000)
                self.mapView.setRegion(zoomRegion, animated: true)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension ScholarsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        if searchText.characters.count > 0 {
            self.searchBarActive = true
            self.filterContentForSearchText()
        } else {
            self.searchBarActive = false
            self.scholarsCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.scholarsCollectionView {
            return self.searchBarActive ? self.searchResults.count : self.currentScholars.count
        } else if collectionView == self.yearCollectionView {
            return self.years.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.scholarsCollectionView {
            let cell = self.scholarsCollectionView.dequeueReusableCell(withReuseIdentifier: "scholarCollectionViewCell", for: indexPath) as! ScholarCollectionViewCell
            let scholar = self.searchBarActive ? self.searchResults[indexPath.item] as! Scholar : self.currentScholars[indexPath.item]
            
            cell.nameLabel.text = scholar.firstName
            if let profilePicURL = Foundation.URL(string: scholar.latestBatch.profilePic) {
                let placeholderImage = UIImage(named: "placeholder")
                cell.profileImageView.af_setImage(withURL: profilePicURL, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false)
            } else {
                print("\(scholar.fullName) has no profile pic or URL is wrong! (URL: \(scholar.latestBatch.profilePic)")
            }
            
            return cell
        } else if collectionView == self.yearCollectionView {
            let cell = self.yearCollectionView.dequeueReusableCell(withReuseIdentifier: "yearCollectionViewCell", for: indexPath) as! YearCollectionViewCell
            
            cell.yearLabel.font = indexPath == self.selectedYearRow ? UIFont.boldSystemFont(ofSize: 15.5) : UIFont.systemFont(ofSize: 14.0)
            cell.yearLabel.text = self.years[indexPath.item].rawValue
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scholarsCollectionView {
            self.searchBar.frame.origin.y = -scrollView.contentOffset.y - 44.0
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ScholarsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if collectionView == self.scholarsCollectionView {
            return CGSize(width: (self.scholarsCollectionView.frame.size.width / 3.0) - 8.0, height: 140.0)
        } else if collectionView == self.yearCollectionView {
            return CGSize(width: 75.0, height: 50.0)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.scholarsCollectionView {
            self.view.endEditing(true)
            
            self.performSegue(withIdentifier: String(describing: ScholarDetailViewController()), sender: indexPath)
        } else if collectionView == self.yearCollectionView {
            let cell = self.yearCollectionView.cellForItem(at: indexPath) as! YearCollectionViewCell
            
            var indexPaths: [IndexPath] = []
            if let previous = self.selectedYearRow {
                indexPaths = [indexPath, previous]
            } else {
                indexPaths = [indexPath]
            }
            
            self.selectedYearRow = indexPath
            
            if indexPaths.first != indexPaths.last {
                self.yearCollectionView.reloadItems(at: indexPaths)
                self.scrollCollectionViewToIndexPath(indexPath.item, animated: true)
                self.currentYear = WWDC(rawValue: cell.yearLabel.text!)!
                self.getCurrentScholars()
            }
        }
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension ScholarsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "scholarDetailViewController") as? ScholarDetailViewController
        let cellPosition = self.scholarsCollectionView.convert(location, from: self.view)
        let cellIndex = self.scholarsCollectionView.indexPathForItem(at: cellPosition)
        
        guard let previewViewController = viewController, let indexPath = cellIndex, let cell = self.scholarsCollectionView.cellForItem(at: indexPath) else {
            return nil
        }
        
        let scholar = self.searchBarActive ? self.searchResults[indexPath.item] as! Scholar : self.currentScholars[indexPath.item]
        previewViewController.setScholar(scholar.id)
        previewViewController.delegate = self
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convert(cell.frame, from: self.scholarsCollectionView)
        
        return previewViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.view.endEditing(true)
        
        self.show(viewControllerToCommit, sender: self)
    }
}

// MARK: - MKMapViewDelegate

extension ScholarsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: QCluster.classForCoder()) {
            var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.reuseId()) as? ClusterAnnotationView
            
            if annotationView == nil {
                annotationView = ClusterAnnotationView(cluster: annotation)
            }
            
            annotationView!.cluster = annotation
            
            return annotationView
        } else if annotation.isKind(of: ScholarAnnotation.classForCoder()) {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "ScholarAnnotation")
            
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ScholarAnnotation")
                pinView?.canShowCallout = true
                pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
                pinView?.rightCalloutAccessoryView!.tintColor = UIColor.black
            } else {
                pinView?.annotation = annotation
            }
            
            pinView?.image = UIImage(named: "scholarMapAnnotation")
            
            return pinView
        }
        
        return nil
    }
    
    func reloadAnnotations() {
        guard self.isViewLoaded else {
            return
        }
        
        let mapRegion = self.mapView.region
        let minNonClusteredSpan = min(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
        let objects = self.qTree.getObjectsIn(mapRegion, minNonClusteredSpan: minNonClusteredSpan) as NSArray
        for object in objects {
            if (object as AnyObject).isKind(of: QCluster()) {
                let c = object as? QCluster
                let neighbours = self.qTree.neighbours(forLocation: (c?.coordinate)!, limitCount: NSInteger((c?.objectsCount)!)) as NSArray
                for neighbour in neighbours {
                    let _ = self.currentScholars.filter({
                        return $0.fullName == ((neighbour as AnyObject).title)!
                    })
                }
            } else {
                let _ = self.currentScholars.filter({
                    return $0.fullName == ((object as AnyObject).title)!
                })
            }
        }
        
        let annotationsToRemove = (self.mapView.annotations as NSArray).mutableCopy() as! NSMutableArray
        annotationsToRemove.remove(self.mapView.userLocation)
        annotationsToRemove.removeObjects(in: objects as [AnyObject])
        self.mapView.removeAnnotations(annotationsToRemove as [AnyObject] as! [MKAnnotation])
        let annotationsToAdd = objects.mutableCopy() as! NSMutableArray
        annotationsToAdd.removeObjects(in: self.mapView.annotations)
        
        self.mapView.addAnnotations(annotationsToAdd as [AnyObject] as! [MKAnnotation])
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.reloadAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.isKind(of: MKAnnotationView.classForCoder()) {
            let annotation = view.annotation as! ScholarAnnotation
            
            self.performSegue(withIdentifier: String(describing: ScholarDetailViewController()), sender: annotation.id)
        }
    }
}
