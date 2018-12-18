//
//  ScholarsMapViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import ClusterKit.MapKit
import DeckTransition

internal final class ScholarsMapViewController: UIViewController, ContainerViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var mapView: MKMapView?
    @IBOutlet private weak var myLocationButtonVisualEffectView: UIVisualEffectView?
    @IBOutlet private weak var myLocationButton: UIButton?
    
    private let locationManager = CLLocationManager()
    
    private var locationStatusManager: LocationStatusManager?
    
    // MARK: - File Private Properties
    
    fileprivate let scholarClusterAnnotationViewIdentifier = "scholarClusterAnnotationView"
    fileprivate let scholarAnnotationViewIdentifier = "scholarAnnotationView"
    
    // MARK: - Internal Properties
    
    internal var scholars = [Scholar]()
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationStatusManager = LocationStatusManager(viewController: self, locationManager: self.locationManager)
        
        self.styleUI()
        self.configureUI()
        self.configureMapContent()
        self.setRegionToDefaultLocation()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.myLocationButtonVisualEffectView?.applyDefaultCornerRadius()
        
        self.myLocationButton?.tintColor = .scholarsPurple
        self.myLocationButton?.applyDefaultCornerRadius()
    }
    
    private func configureUI() {
        self.title = "Map"
        
        let myLocationButtonImage = UIImage(named: "myLocationIcon")
        self.myLocationButton?.setImage(myLocationButtonImage, for: .normal)
        self.myLocationButton?.contentMode = .center
        
        let clusterAlgorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        clusterAlgorithm.cellSize = 200.0
        self.mapView?.clusterManager.algorithm = clusterAlgorithm
        self.mapView?.clusterManager.marginFactor = 1
        self.mapView?.showsUserLocation = true
    }
    
    // MARK: - Actions
    
    @IBAction internal func myLocationButtonTapped() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.locationStatusManager?.handleLocationServicesDisabled()
            return
        }
        
        guard CLLocationManager.isAuthorized() else {
            self.locationStatusManager?.handleAuthorizationFailure()
            return
        }
        
        self.setRegionToUserLocation()
    }
    
    // MARK: - Internal Functions
    
    internal func switchedToViewController() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    internal func configureMapContent() {
		clearMapContent()
        let annotations = ScholarsMapAnnotationsFactory.annotations(for: self.scholars)
        self.mapView?.clusterManager.addAnnotations(annotations)
    }
	
	internal func clearMapContent(){
		if let annotations = mapView?.clusterManager.annotations{
			mapView?.clusterManager.removeAnnotations(annotations)
		}
	}
    
    // MARK: - Private Functions
    
    private func setRegionToDefaultLocation() {
        guard let mapView = self.mapView else {
            return
        }
        
        let distance: CLLocationDistance = 10000000.0
        let defaultRegion = MKCoordinateRegion.init(center: mapView.centerCoordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(defaultRegion, animated: true)
    }
    
    private func setRegionToUserLocation() {
        guard let mapView = self.mapView else {
            return
        }
        
        let userCoordinate = mapView.userLocation.coordinate
        let distance: CLLocationDistance = 2500000.0
        let userRegion = MKCoordinateRegion.init(center: userCoordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(userRegion, animated: true)
    }
}

extension ScholarsMapViewController: MKMapViewDelegate {
	
    // MARK: - Internal Functions
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let cluster = annotation as? CKCluster else {
            return nil
        }
        
        if cluster.count > 1 {
            return self.scholarClusterAnnotationView(in: cluster, annotation: annotation, mapView: mapView)
        }
		else {
            return self.scholarAnnotationView(annotation: cluster.firstAnnotation!, mapView: mapView)
        }
    }
    
    internal func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.clusterManager.updateClustersIfNeeded()
    }
    
    internal func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        guard let cluster = view.annotation as? CKCluster else {
            return
        }
		
        
		if cluster.count > 1{
			self.show(cluster: cluster, mapView: mapView)
		}
		else if let scholarAnnotation = cluster.firstAnnotation! as? ScholarAnnotation{
//            self.presentProfileViewController(scholarId: scholarAnnotation.scholar.id)
		}
    }
    
    // MARK: - Private Functions
    
    private func show(cluster: CKCluster, mapView: MKMapView) {
        let edgeInset: CGFloat = 50.0
        let edgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        mapView.show(cluster, edgePadding: edgeInsets, animated: true)
    }
    
    
    private func scholarAnnotationView(annotation: MKAnnotation, mapView: MKMapView) -> ScholarAnnotationView {
		guard let annotation = annotation as? ScholarAnnotation else { fatalError() }
        let defaultAnnotationView = ScholarAnnotationView(annotation: annotation, reuseIdentifier: self.scholarAnnotationViewIdentifier)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.scholarAnnotationViewIdentifier) as? ScholarAnnotationView ?? defaultAnnotationView
        return annotationView
    }
    
    private func scholarClusterAnnotationView(in cluster: CKCluster, annotation: MKAnnotation, mapView: MKMapView) -> ScholarClusterAnnotationView {
        let defaultAnnotationView = ScholarClusterAnnotationView(annotation: annotation, reuseIdentifier: self.scholarClusterAnnotationViewIdentifier)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.scholarClusterAnnotationViewIdentifier) as? ScholarClusterAnnotationView ?? defaultAnnotationView
        
        let clusterCountText = String(cluster.count)
        annotationView.setLabel(text: clusterCountText)
        return annotationView
    }
}
