//
//  ScholarsMapViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import DeckTransition
import MapKit
import UIKit

extension K {
    static let scholarAnnotationReuseIdentifier = "scholarAnnotationReuseIdentifier"
    static let scholarClusterAnnotationReuseIdentifier = "scholarClusterAnnotationReuseIdentifier"
}

final class ScholarsMapViewController: UIViewController, ContainerViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var toolbar: HoverBar!
    private var overviewButton: UIButton!
    private var locationButton: MKUserTrackingBarButtonItem!
    private var compassButton: MKCompassButton!
    
    private let locationManager = CLLocationManager()
    
    private var locationStatusManager: LocationStatusManager?
    
    // MARK: - Properties
    
    var scholars: [Scholar] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationStatusManager = LocationStatusManager(viewController: self, locationManager: locationManager)

        setupUI()
        configureUI()
        configureMapContent()
        setRegionToDefaultLocation()
    }
    
    // MARK: - UI

    private func setupUI() {
        // Toolbar
        overviewButton = UIButton(type: .custom)
        overviewButton.setImage(UIImage(named: "globe"), for: .normal)
        overviewButton.tintColor = .adjustingScholarsPurple
        overviewButton.addTarget(self, action: #selector(overviewButtonTapped), for: .touchUpInside)

        locationButton = MKUserTrackingBarButtonItem(mapView: mapView)
        locationButton.tintColor = .adjustingScholarsPurple

        toolbar.orientation = .vertical
        toolbar.items = [overviewButton, locationButton]

        // Compass
        compassButton = MKCompassButton(mapView: mapView)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.compassVisibility = .adaptive
        view.addSubview(compassButton)
        NSLayoutConstraint.activate([
            compassButton.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            compassButton.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 12)
        ])
    }
    
    private func configureUI() {
        title = "Map"

        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        mapView.register(ScholarAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.scholarAnnotationReuseIdentifier)
        mapView.register(ScholarClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.scholarClusterAnnotationReuseIdentifier)
    }

    // MARK: - User Interaction

    @objc
    private func overviewButtonTapped() {
        setRegionToDefaultLocation(animated: true)
    }
    
    // MARK: - Functions
    
    func switchedToViewController() {
        setRegionToDefaultLocation()
    }
    
    func configureMapContent() {
		clearMapContent()
        let annotations = ScholarsMapAnnotationsFactory.annotations(for: scholars)
        mapView.addAnnotations(annotations)
    }
	
	func clearMapContent(){
        mapView.removeAnnotations(mapView.annotations)
	}
    
    // MARK: - Private Functionn

    private func setRegionToCoordinate(_ coordinate: CLLocationCoordinate2D, distance: CLLocationDistance = 500000) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
    private func setRegionToDefaultLocation(animated: Bool = false) {
        setRegionToCoordinate(mapView.centerCoordinate, distance: 10000000)
    }
    
    private func setRegionToUserLocation() {
        setRegionToCoordinate(mapView.userLocation.coordinate, distance: 750000)
    }

    private func setRegionToAnnotation(_ annotation: MKAnnotation) {
        setRegionToCoordinate(annotation.coordinate)
    }

    private func setRegionToCluster(_ annotation: MKClusterAnnotation) {
        let rect = boundingRectForAnnotations(annotation.memberAnnotations)
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30), animated: true)
    }

    private func boundingRectForAnnotations(_ annotations: [MKAnnotation]) -> MKMapRect {
        return annotations
            .map { MKMapRect(origin: MKMapPoint($0.coordinate), size: MKMapSize(width: 50, height: 50)) }
            .reduce(MKMapRect.null) { $0.union($1) }
    }
}

extension ScholarsMapViewController: MKMapViewDelegate {
	
    // MARK: - Functions

    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        guard CLLocationManager.locationServicesEnabled() else {
            locationStatusManager?.handleLocationServicesDisabled()
            return
        }

        locationStatusManager?.handleAuthorizationFailure()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier: String
        if annotation is ScholarAnnotation {
            identifier = K.scholarAnnotationReuseIdentifier
        } else if let annotation = annotation as? MKClusterAnnotation,
            annotation.memberAnnotations.first is ScholarAnnotation {
            identifier = K.scholarClusterAnnotationReuseIdentifier
        } else {
            return nil
        }

        return mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        // If cluster, zoom to cluster
        if let annotation = annotation as? MKClusterAnnotation {
            setRegionToCluster(annotation)
        } else if let annotation = annotation as? ScholarAnnotation {
            setRegionToAnnotation(annotation)
        }

        // TODO: show profile
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKClusterAnnotation {
            return
        } else if view is ScholarAnnotationView {
            setRegionToDefaultLocation(animated: true)
        }
    }
}
