//
//  MapViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import ClusterKit.MapKit

internal final class MapViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var mapView: MKMapView?
    
    // MARK: - File Private Properties
    
    fileprivate let scholarClusterAnnotationViewIdentifier = "scholarClusterAnnotationView"
    fileprivate let scholarAnnotationViewIdentifier = "scholarAnnotationView"
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.configureMapContent()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        
    }
    
    private func configureUI() {
        self.title = "Map"
        
        let clusterAlgorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        clusterAlgorithm.cellSize = 200
        
        self.mapView?.clusterManager.algorithm = clusterAlgorithm
        self.mapView?.clusterManager.marginFactor = 1
    }
    
    // MARK: - Private Functions
    
    private func configureMapContent() {
        let scholars: [ExampleScholar] = [ScholarOne(), ScholarTwo(), ScholarThree()]
        let annotations = MapAnnotationsFactory.annotations(for: scholars)
        self.mapView?.clusterManager.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    
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
        if let cluster = view.annotation as? CKCluster, cluster.count > 1 {
            self.show(cluster: cluster, mapView: mapView)
        }
    }
    
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "ProfileViewController", sender: nil)
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
