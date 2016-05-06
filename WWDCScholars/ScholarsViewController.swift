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

class ScholarsViewController: UIViewController, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate, ContactButtonDelegate {
    @IBOutlet private weak var yearCollectionView: UICollectionView!
    @IBOutlet private weak var loadingView: ActivityIndicatorView!
    @IBOutlet private weak var scholarsCollectionView: UICollectionView!
    @IBOutlet private weak var extendedNavigationContainer: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var rightArrowImageView: UIImageView!
    @IBOutlet private weak var leftArrowImageView: UIImageView!
    @IBOutlet private weak var loginBarButtonItem: UIBarButtonItem!
    
    private let years: [WWDC] = [.WWDC2011, .WWDC2012, .WWDC2013, .WWDC2014, .WWDC2015, .WWDC2016]
    private let locationManager = CLLocationManager()
    
    private lazy var qTree = QTree()

    private var currentYear: WWDC = .WWDC2016
    private var currentScholars: [Scholar] = []
    private var loggedIn = false
    private var isMapInitalized = false
    private var myLocation: CLLocationCoordinate2D?
    private var currentViewType: CurrentViewType = .List
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGestureRecognizerLoginBarButtomItem = UILongPressGestureRecognizer(target: self, action: #selector(ScholarsViewController.showEditDetailsModal(_:)))
        self.view.addGestureRecognizer(longPressGestureRecognizerLoginBarButtomItem)
        
        self.styleUI()
        self.loadingView.startAnimating()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        self.currentYear = years[self.years.count - 1]
        
        ScholarsKit.sharedInstance.loadScholars({
            if self.loadingView.isAnimating() {
                self.loadingView.stopAnimating()
            }
            
            self.getCurrentScholars()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        if !UserDefaults.hasOpenedApp {
            self.performSegueWithIdentifier(String(IntroViewController), sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ScholarDetailViewController) {
            if let indexPath = sender as? NSIndexPath {
                let destinationViewController = segue.destinationViewController as! ScholarDetailViewController
                destinationViewController.currentScholar = self.currentScholars[indexPath.item]
            }
        }
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Scholars"
        
        self.extendedNavigationContainer.applyExtendedNavigationBarContainerStyle()
        self.applyExtendedNavigationBarStyle()
        self.leftArrowImageView.tintColor = UIColor.transparentWhiteColor()
        self.rightArrowImageView.tintColor = UIColor.transparentWhiteColor()
    }
    
    private func initialzeMap() {
        // Map related
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
        }
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 38.8833, longitude: -77.0167), 10000000, 10000000)
        self.mapView.setRegion(zoomRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.mapType = .Standard
        
        //The "Find me" button
        let button = UIButton(type: .Custom)
        button.frame = CGRect(x: UIScreen.mainScreen().bounds.width - 58, y: self.mapView.frame.size.height - 58, width: 50, height: 50)
        button.setImage(UIImage(named: "myLocation"), forState: .Normal)
        button.addTarget(self, action: #selector(ScholarsViewController.buttonAction(_:)), forControlEvents: .TouchUpInside)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        button.layer.shadowRadius = 2.0
        button.layer.cornerRadius = button.frame.width / 2.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.whiteColor()
        
        self.mapView.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.loadingView.isAnimating() {
            self.loadingView.stopAnimating()
        }
        
        self.getCurrentScholars()
        
        let index = self.years.indexOf(self.currentYear)!
        self.yearCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .Left, animated: false)
        self.updateArrowsForIndex(index)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - IBAction
    
    @IBAction func accountButtonTapped(sender: AnyObject) {
        self.loggedIn ? self.showEditDetailsModal() : self.showSignInModal()
    }
    
    @IBAction func mapButtonTapped(sender: AnyObject) {
        if !self.isMapInitalized {
            self.initialzeMap()
            self.isMapInitalized = true
        }
        
        self.switchView()
    }
    
    // MARK: - Private functions
    
    private func switchView() {
        UIView.animateWithDuration(0.2, animations: {
            self.mainView.alpha = self.currentViewType == .List ? 0.0 : 1.0
            self.mapView.alpha = self.currentViewType == .Map ? 0.0 : 1.0
        })
        
        self.currentViewType = self.currentViewType == .List ? .Map : .List
    }
    
    private func getCurrentScholars() {
        self.currentScholars = DatabaseManager.sharedInstance.scholarsForWWDCBatch(self.currentYear)
        
        self.scholarsCollectionView.reloadData()
        self.addScholarToQTree()
    }
    
    private func addScholarToQTree() {
        self.qTree.cleanup()
        
        for scholar in self.currentScholars {
            let location = scholar.location
            let annotation = ScholarAnnotation(coordinate: CLLocationCoordinate2DMake(location.latitude, location.longitude), title: scholar.fullName, subtitle: location.name)
            self.qTree.insertObject(annotation)
        }
        
        self.reloadAnnotations()
    }

    private func scrollCollectionViewToIndexPath(index: Int) {
        self.yearCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        self.scrollViewDidEndDecelerating(self.yearCollectionView)
    }
    
    private func showSignInModal() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("SignInVC")
        
        modalViewController.modalPresentationStyle = .OverCurrentContext
        modalViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.view.window?.rootViewController?.view.window?.rootViewController!.presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    private func showEditDetailsModal() {
        
    }
    
    // MARK: - Internal functions
    
    internal func openContactURL(url: String) {
        let viewController = SFSafariViewController(URL: NSURL(string: url)!)
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
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
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func showEditDetailsModal(longPressGestureRecognizerLoginBarButtomItem: UIGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController = storyboard.instantiateViewControllerWithIdentifier("EditDetailsNC")
        
        modalViewController.modalPresentationStyle = .FullScreen
        modalViewController.modalTransitionStyle = .CoverVertical
        self.presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    internal func buttonAction(sender: UIButton!) {
        let myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
        let zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 5000000, 5000000)
        self.mapView.setRegion(zoomRegion, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.yearCollectionView {
            //scholarsCollectionView page changed, update scholars list
            
            let currentIndex = Int(self.yearCollectionView.contentOffset.x / self.view.frame.size.width)
            self.currentYear = self.years[currentIndex]
            
            self.getCurrentScholars()
            self.updateArrowsForIndex(currentIndex)
        }
    }
    
    private func updateArrowsForIndex(currentIndex: Int) {
        UIView.animateWithDuration(0.2, animations: {
            self.leftArrowImageView.alpha = currentIndex == 0 ? 0.0 : 1.0
            self.rightArrowImageView.alpha = currentIndex == self.years.count - 1 ? 0.0 : 1.0
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.yearCollectionView {
            UIView.animateWithDuration(0.2, animations: {
                self.leftArrowImageView.alpha = 0.0
                self.rightArrowImageView.alpha = 0.0
            })
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.scholarsCollectionView {
            return self.currentScholars.count
        } else if collectionView == self.yearCollectionView {
            return self.years.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.scholarsCollectionView {
            let cell = self.scholarsCollectionView.dequeueReusableCellWithReuseIdentifier("scholarCollectionViewCell", forIndexPath: indexPath) as! ScholarCollectionViewCell
            let scholar = self.currentScholars[indexPath.item]
            
            cell.nameLabel.text = scholar.firstName
            if scholar.profilePicURL != "" {
                cell.profileImageView.af_setImageWithURL(NSURL(string: scholar.profilePicURL)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
            }
            
            return cell
        } else if collectionView == self.yearCollectionView {
            let cell = self.yearCollectionView.dequeueReusableCellWithReuseIdentifier("yearCollectionViewCell", forIndexPath: indexPath) as! YearCollectionViewCell
            
            cell.yearLabel.text = self.years[indexPath.item].rawValue
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ScholarsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.scholarsCollectionView {
            return CGSize(width: (self.scholarsCollectionView.frame.size.width / 3.0) - 8.0, height: 140.0)
        } else if collectionView == self.yearCollectionView {
            return CGSize(width: self.view.bounds.width, height: 50.0)
        }
        
        return CGSize.zero
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.scholarsCollectionView {
            self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: indexPath)
        } else if collectionView == self.yearCollectionView {
            print(indexPath.row)
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
        
        let scholar = self.currentScholars[indexPath.item]
        previewViewController.currentScholar = scholar
        previewViewController.delegate = self
        previewViewController.preferredContentSize = CGSize.zero
        previewingContext.sourceRect = self.view.convertRect(cell.frame, fromView: self.scholarsCollectionView)
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
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
}
