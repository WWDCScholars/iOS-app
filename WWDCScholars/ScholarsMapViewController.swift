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
    @IBOutlet private weak var userTrackingButtonEffectView: UIVisualEffectView!
    private var userTrackingButton: MKUserTrackingButton!
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
        styleUI()
        configureUI()
        configureMapContent()
        setRegionToDefaultLocation()
    }
    
    // MARK: - UI

    private func setupUI() {
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        userTrackingButtonEffectView.contentView.addSubview(userTrackingButton)
        NSLayoutConstraint.activate([
            userTrackingButton.centerXAnchor.constraint(equalTo: userTrackingButtonEffectView.contentView.centerXAnchor),
            userTrackingButton.centerYAnchor.constraint(equalTo: userTrackingButtonEffectView.contentView.centerYAnchor)
        ])

        compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .adaptive
    }
    
    private func styleUI() {
        userTrackingButtonEffectView.applyDefaultCornerRadius()
        userTrackingButton.tintColor = .adjustingScholarsPurple
    }
    
    private func configureUI() {
        title = "Map"

        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        mapView.register(ScholarAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.scholarAnnotationReuseIdentifier)
        mapView.register(ScholarClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.scholarClusterAnnotationReuseIdentifier)
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
    
    // MARK: - Private Functions
    
    private func setRegionToDefaultLocation() {
        let distance: CLLocationDistance = 10000000.0
        let defaultRegion = MKCoordinateRegion.init(center: mapView.centerCoordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(defaultRegion, animated: true)
    }
    
    private func setRegionToUserLocation() {
        let userCoordinate = mapView.userLocation.coordinate
        let distance: CLLocationDistance = 750000.0
        let userRegion = MKCoordinateRegion.init(center: userCoordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(userRegion, animated: true)
    }
}

extension ScholarsMapViewController: MKMapViewDelegate {
	
    // MARK: - Functions
    
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
//        mapView.deselectAnnotation(view.annotation, animated: false)

        guard let _ = view.annotation else { return }

        // If cluster, zoom to cluster

        // Else, show profile
    }
}
