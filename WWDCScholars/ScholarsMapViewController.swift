//
//  ScholarsMapViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import ClusterKit.MapKit
import DeckTransition
import CoreLocation

internal final class ScholarsMapViewController: UIViewController, ContainerViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var mapView: MKMapView?
    @IBOutlet private weak var myLocationButtonVisualEffectView: UIVisualEffectView?
    @IBOutlet private weak var myLocationButton: UIButton?
    
    private let locationManager = CLLocationManager()
    
    // MARK: - File Private Properties
    
    fileprivate let scholarClusterAnnotationViewIdentifier = "scholarClusterAnnotationView"
    fileprivate let scholarAnnotationViewIdentifier = "scholarAnnotationView"
    
    // MARK: - Internal Properties
    
    internal var scholars = [ExampleScholar]()
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.configureMapContent()
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
        
    }
    
    // MARK: - Internal Functions Functions
    
    internal func switchedToViewController() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Private Functions
    
    private func configureMapContent() {
        guard let mapView = self.mapView else {
            return
        }
        
        let annotations = ScholarsMapAnnotationsFactory.annotations(for: self.scholars)
        mapView.clusterManager.addAnnotations(annotations)
        
        let distance: CLLocationDistance = 10000000.0
        let defaultRegion = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, distance, distance)
        mapView.setRegion(defaultRegion, animated: true)
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
        } else {
            return self.scholarAnnotationView(annotation: annotation, mapView: mapView)
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
        
        let isCluster = cluster.count > 1
        isCluster ? self.show(cluster: cluster, mapView: mapView) : self.presentProfileViewController()
    }
    
    // MARK: - Private Functions
    
    private func show(cluster: CKCluster, mapView: MKMapView) {
        let edgeInset: CGFloat = 50.0
        let edgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        mapView.show(cluster, edgePadding: edgeInsets, animated: true)
    }
    
    private func scholarAnnotationView(annotation: MKAnnotation, mapView: MKMapView) -> ScholarAnnotationView {
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
