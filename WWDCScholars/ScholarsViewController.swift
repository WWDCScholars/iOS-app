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

enum CurrentViewType {
    case List
    case Map
}

class ScholarsViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, QuickActionsDelegate {
    @IBOutlet private weak var yearCollectionView: UICollectionView!
    @IBOutlet private weak var loadingView: ActivityIndicatorView!
    @IBOutlet private weak var scholarsCollectionView: UICollectionView!
    @IBOutlet private weak var extendedNavigationContainer: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var loginBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var mapBarButtonItem: UIBarButtonItem!
    
    private let years: [WWDC] = [.WWDC2011, .WWDC2012, .WWDC2013, .WWDC2014, .WWDC2015, .WWDC2016, .Saved]
    private let locationManager = CLLocationManager()
    private let noContentLabel = UILabel()
    
    private lazy var qTree = QTree()

    private var currentYear: WWDC = .WWDC2016
    private var currentScholars: [Scholar] = []
    private var searchResults = NSArray()
    private var searchBarActive = false
    private var loggedIn = false
    private var isMapInitalized = false
    private var myLocation: CLLocationCoordinate2D?
    private var currentViewType: CurrentViewType = .List
    private var searchText = ""
    private var selectedYearRow: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.styleUI()
        
        self.currentYear = years[self.years.count - 2]
        
        ScholarsKit.sharedInstance.loadScholars({
            if self.loadingView.isAnimating() {
                self.loadingView.stopAnimating()
            }
            
            for (index, scholar) in DatabaseManager.sharedInstance.getAllScholars().enumerate() {
                SpotlightManager.sharedInstance.indexScholar(scholar, atIndex: index)
            }
            
            self.getCurrentScholars()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ScholarDetailViewController) {
            let destinationViewController = segue.destinationViewController as! ScholarDetailViewController
            destinationViewController.delegate = self
            
            if let indexPath = sender as? NSIndexPath {
                destinationViewController.currentScholar = self.searchBarActive ? self.searchResults[indexPath.item] as! Scholar : self.currentScholars[indexPath.item]
            } else if let scholarID = sender as? String {
                destinationViewController.currentScholar = DatabaseManager.sharedInstance.scholarForId(scholarID)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let index = self.years.indexOf(self.currentYear)!
        self.selectedYearRow = NSIndexPath(forItem: index, inSection: 0)
        self.scrollCollectionViewToIndexPath(index, animated: false)
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.scholarsCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
     
        self.loadingView.startAnimating()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        let frame = self.view.frame
        self.noContentLabel.text = "Looks like there's no Scholars here yet!"
        self.noContentLabel.frame = CGRect(x: frame.origin.x + 16.0, y: -100.0, width: frame.width - 32.0, height: frame.height)
        self.noContentLabel.textColor = UIColor.mediumTextColor()
        self.noContentLabel.numberOfLines = 0
        self.noContentLabel.textAlignment = .Center
    }
    
    private func styleUI() {
        self.title = "Scholars"
        
        self.searchBar.tintColor = UIColor.scholarsPurpleColor()
        self.extendedNavigationContainer.applyExtendedNavigationBarContainerStyle()
        self.applyExtendedNavigationBarStyle()
    }
    
    private func configureMap() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
        }
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 10000000.0, 10000000.0)
        self.mapView.setRegion(zoomRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.mapType = .Standard
        
        //The "Find me" button
        let locateButton = UIButton(type: .Custom)
        locateButton.frame = CGRect(x: UIScreen.mainScreen().bounds.width - 45, y: UIScreen.mainScreen().bounds.height - 210, width: 33, height: 33)
        locateButton.setImage(UIImage(named: "locationButton"), forState: .Normal)
        locateButton.addTarget(self, action: #selector(ScholarsViewController.locateButtonAction), forControlEvents: .TouchUpInside)
        locateButton.layer.shadowOpacity = 0.5
        locateButton.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        locateButton.layer.shadowRadius = 2.0
        locateButton.layer.cornerRadius = locateButton.frame.width / 2.0
        locateButton.layer.masksToBounds = true
        locateButton.backgroundColor = UIColor.scholarsPurpleColor()
        
        self.mapView.addSubview(locateButton)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - IBActions
    
    @IBAction func accountButtonTapped(sender: AnyObject) {
        self.loggedIn ? self.showEditDetailsModal() : self.showSignInModal()
    }
    
    @IBAction func mapButtonTapped(sender: AnyObject) {
        if !self.isMapInitalized {
            self.configureMap()
            self.isMapInitalized = true
        }
        
        self.switchView()
    }
    
    // MARK: - Private functions
    
    private func reloadScholarsCollectionViewWithAnimation() {
        UIView.transitionWithView(self.scholarsCollectionView, duration: 0.2, options: .TransitionCrossDissolve, animations: {
            self.scholarsCollectionView.reloadData()
            }, completion: nil)
    }
    
    private func cancelSearching(setOffset: Bool = false) {
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
        
        self.reloadScholarsCollectionViewWithAnimation()
    }
    
    private func filterContentForSearchText() {
        let resultPredicate = NSPredicate(format: "fullName contains[cd] %@", self.searchText)
        self.searchResults = (self.currentScholars as NSArray).filteredArrayUsingPredicate(resultPredicate)
        
        self.scholarsCollectionView.reloadData()
    }
    
    private func switchView() {
        UIView.animateWithDuration(0.2, animations: {
            self.mapBarButtonItem.image = UIImage(named: self.currentViewType == . List ? "gridIcon" : "mapIcon")
            self.mainView.alpha = self.currentViewType == .List ? 0.0 : 1.0
            self.mapView.alpha = self.currentViewType == .Map ? 0.0 : 1.0
        })
        
        self.currentViewType = self.currentViewType == .List ? .Map : .List
        
        self.cancelSearching()
    }
    
    private func getCurrentScholars() {
        self.currentScholars = self.currentYear == .Saved ? self.getFavorites() : DatabaseManager.sharedInstance.scholarsForWWDCBatch(self.currentYear)
        
        if self.searchBarActive {
            self.filterContentForSearchText()
        } else {
            self.reloadScholarsCollectionViewWithAnimation()
        }
        
        if self.currentScholars.count == 0 && !self.noContentLabel.isDescendantOfView(self.scholarsCollectionView) {
            self.scholarsCollectionView.addSubview(self.noContentLabel)
        } else if self.currentScholars.count > 0 {
            self.noContentLabel.removeFromSuperview()
        }
        
        self.addScholarToQTree()
    }
    
    private func getFavorites() -> [Scholar] {
        var favorites: [Scholar] = []
        
        for scholarID in UserDefaults.favorites {
            if let scholar = DatabaseManager.sharedInstance.scholarForId(scholarID) {
                favorites.append(scholar)
            }
        }
        
        return favorites
    }
    
    private func addScholarToQTree() {
        self.qTree.cleanup()
        
        for scholar in self.currentScholars {
            let location = scholar.location
            let annotation = ScholarAnnotation(coordinate: CLLocationCoordinate2DMake(location.latitude, location.longitude), title: scholar.fullName, subtitle: location.name, id: scholar.id)
            self.qTree.insertObject(annotation)
        }
        
        self.reloadAnnotations()
    }

    private func scrollCollectionViewToIndexPath(index: Int, animated: Bool) {
        self.yearCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: animated)
    }
    
    private func showSignInModal() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("SignInVC")
        
        modalViewController.modalPresentationStyle = .OverCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.view.window?.rootViewController?.view.window?.rootViewController!.presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    // MARK: - Internal functions
    
    internal func refreshScholarsWithNewFavorite() {
        self.getCurrentScholars()
    }
    
    internal func openContactURL(url: String) {
        let viewController = SFSafariViewController(URL: NSURL(string: url)!)
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    internal func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func composeEmail(address: String) {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([address])
            
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    internal func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func showEditDetailsModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("EditDetailsNC")
        
        modalViewController.modalPresentationStyle = .FullScreen
        modalViewController.modalTransitionStyle = .CoverVertical
        self.presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    internal func locateButtonAction(sender: UIButton!) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
                let controller = UIAlertController(title: "Enable Location Services", message: "To view your current location, please first enable location services. This can be done from within your device's settings.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                controller.addAction(cancelAction)
                
                let jumpToSettingsAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                
                controller.addAction(jumpToSettingsAction)
                
                self.presentViewController(controller, animated: true, completion: nil)
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                let myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
                let zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 5000000, 5000000)
                self.mapView.setRegion(zoomRegion, animated: true)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension ScholarsViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        if searchText.characters.count > 0 {
            self.searchBarActive = true
            self.filterContentForSearchText()
        } else {
            self.searchBarActive = false
            self.scholarsCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.cancelSearching(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar!.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.scholarsCollectionView {
            return self.searchBarActive ? self.searchResults.count : self.currentScholars.count
        } else if collectionView == self.yearCollectionView {
            return self.years.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.scholarsCollectionView {
            let cell = self.scholarsCollectionView.dequeueReusableCellWithReuseIdentifier("scholarCollectionViewCell", forIndexPath: indexPath) as! ScholarCollectionViewCell
            let scholar = self.searchBarActive ? self.searchResults[indexPath.item] as! Scholar : self.currentScholars[indexPath.item]
            
            cell.nameLabel.text = scholar.firstName
            if let profilePicURL = NSURL(string: scholar.profilePicURL) {
                cell.profileImageView.af_setImageWithURL(profilePicURL, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
            } else {
                print("\(scholar.fullName) has no profile pic or URL is wrong! (URL: \(scholar.profilePicURL)")
            }
            
            return cell
        } else if collectionView == self.yearCollectionView {
            let cell = self.yearCollectionView.dequeueReusableCellWithReuseIdentifier("yearCollectionViewCell", forIndexPath: indexPath) as! YearCollectionViewCell
            
            cell.yearLabel.font = indexPath == self.selectedYearRow ? UIFont.boldSystemFontOfSize(15.5) : UIFont.systemFontOfSize(14.0)
            cell.yearLabel.text = self.years[indexPath.item].rawValue
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scholarsCollectionView {
            self.searchBar.frame.origin.y = -scrollView.contentOffset.y - 44.0
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ScholarsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.scholarsCollectionView {
            return CGSize(width: (self.scholarsCollectionView.frame.size.width / 3.0) - 8.0, height: 140.0)
        } else if collectionView == self.yearCollectionView {
            return CGSize(width: 75.0, height: 50.0)
        }
        
        return CGSize.zero
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.scholarsCollectionView {
            self.view.endEditing(true)
            
            self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: indexPath)
        } else if collectionView == self.yearCollectionView {
            let cell = self.yearCollectionView.cellForItemAtIndexPath(indexPath) as! YearCollectionViewCell
            
            var indexPaths: [NSIndexPath] = []
            if let previous = self.selectedYearRow {
                indexPaths = [indexPath, previous]
            } else {
                indexPaths = [indexPath]
            }
            
            self.selectedYearRow = indexPath
            
            if indexPaths.first != indexPaths.last {
                self.yearCollectionView.reloadItemsAtIndexPaths(indexPaths)
                self.scrollCollectionViewToIndexPath(indexPath.item, animated: true)
                self.currentYear = WWDC(rawValue: cell.yearLabel.text!)!
                self.getCurrentScholars()
            }
        }
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension ScholarsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("scholarDetailViewController") as? ScholarDetailViewController
        let cellPosition = self.scholarsCollectionView.convertPoint(location, fromView: self.view)
        let cellIndex = self.scholarsCollectionView.indexPathForItemAtPoint(cellPosition)
        
        guard let previewViewController = viewController, indexPath = cellIndex, cell = self.scholarsCollectionView.cellForItemAtIndexPath(indexPath) else {
            return nil
        }
        
        let scholar = self.searchBarActive ? self.searchResults[indexPath.item] as! Scholar : self.currentScholars[indexPath.item]
        previewViewController.currentScholar = scholar
        previewViewController.delegate = self
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convertRect(cell.frame, fromView: self.scholarsCollectionView)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.view.endEditing(true)
        
        self.showViewController(viewControllerToCommit, sender: self)
    }
}

// MARK: - MKMapViewDelegate

extension ScholarsViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(QCluster.classForCoder()) {
            var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(ClusterAnnotationView.reuseId()) as? ClusterAnnotationView
            
            if annotationView == nil {
                annotationView = ClusterAnnotationView(cluster: annotation)
            }
            
            annotationView!.cluster = annotation
            
            return annotationView
        } else if annotation.isKindOfClass(ScholarAnnotation.classForCoder()) {
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("ScholarAnnotation")
            
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ScholarAnnotation")
                pinView?.canShowCallout = true
                pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
                pinView?.rightCalloutAccessoryView!.tintColor = UIColor.blackColor()
            } else {
                pinView?.annotation = annotation
            }
            
            pinView?.image = UIImage(named: "scholarMapAnnotation")
            
            return pinView
        }
        
        return nil
    }
    
    func reloadAnnotations() {
        guard self.isViewLoaded() else {
            return
        }
        
        let mapRegion = self.mapView.region
        let minNonClusteredSpan = min(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5
        let objects = self.qTree.getObjectsInRegion(mapRegion, minNonClusteredSpan: minNonClusteredSpan) as NSArray
        for object in objects {
            if object.isKindOfClass(QCluster) {
                let c = object as? QCluster
                let neighbours = self.qTree.neighboursForLocation((c?.coordinate)!, limitCount: NSInteger((c?.objectsCount)!)) as NSArray
                for neighbour in neighbours {
                    let _ = self.currentScholars.filter({
                        return $0.fullName == (neighbour.title)!
                    })
                }
            } else {
                let _ = self.currentScholars.filter({
                    return $0.fullName == (object.title)!
                })
            }
        }
        
        let annotationsToRemove = (self.mapView.annotations as NSArray).mutableCopy() as! NSMutableArray
        annotationsToRemove.removeObject(self.mapView.userLocation)
        annotationsToRemove.removeObjectsInArray(objects as [AnyObject])
        self.mapView.removeAnnotations(annotationsToRemove as [AnyObject] as! [MKAnnotation])
        let annotationsToAdd = objects.mutableCopy() as! NSMutableArray
        annotationsToAdd.removeObjectsInArray(self.mapView.annotations)
        
        self.mapView.addAnnotations(annotationsToAdd as [AnyObject] as! [MKAnnotation])
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.reloadAnnotations()
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.isKindOfClass(MKAnnotationView.classForCoder()) {
            let annotation = view.annotation as! ScholarAnnotation
            
            self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: annotation.id)
        }
    }
}
