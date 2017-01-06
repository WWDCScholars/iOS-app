//
//  LocationSelectViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage
import Alamofire

protocol LocationSelectedDelegate {
    func updateLocation(_ location: CLLocationCoordinate2D)
}

class LocationSelectViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    @IBOutlet fileprivate weak var mapView: MKMapView!
    
    fileprivate var searchController: UISearchController!
    fileprivate var annotation: MKAnnotation!
    fileprivate var localSearchRequest: MKLocalSearchRequest!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var pointAnnotation: MKPointAnnotation!
    fileprivate var pinAnnotationView: MKPinAnnotationView!
    
    var passedLocation: CLLocationCoordinate2D?
    var delegate: LocationSelectedDelegate?
    
    override func viewDidLoad() {
        self.addAnnotation(self.passedLocation)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LocationSelectViewController.longPressGestureActivated(_:)))
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Annotations
    
    func mapView(_ aMapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        pinView.pinTintColor = UIColor.scholarsPurpleColor()
        
        return pinView
    }
    
    // MARK: - Internal functions
    
    internal func longPressGestureActivated(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let locationInView = gestureRecognizer.location(in: self.mapView)
            let pinCoordinates = self.mapView.convert(locationInView, toCoordinateFrom: self.mapView)
            
            self.addAnnotation(pinCoordinates)
        }
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        
        searchBar.resignFirstResponder()
        
        self.localSearchRequest = MKLocalSearchRequest()
        self.localSearchRequest.naturalLanguageQuery = searchBar.text
        self.localSearch = MKLocalSearch(request: self.localSearchRequest)
        self.localSearch.start {(localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Location not found", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude,longitude: localSearchResponse!.boundingRegion.center.longitude)
            self.addAnnotation(coordinates)
        }
    }
    
    // MARK: - Private functions
    
    fileprivate func addAnnotation(_ coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        LocationManager.sharedInstance.getLocationDetails(coordinates, completion: {(locationDetails) -> Void in
            annotation.title = locationDetails.locality
            annotation.subtitle = locationDetails.country
            
            if self.mapView.annotations.count > 0 {
                self.mapView.removeAnnotation(self.mapView.annotations.first!)
            }
            
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        if let coordinates = self.mapView.annotations.first?.coordinate {
            self.delegate?.updateLocation(coordinates)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: AnyObject) {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.present(self.searchController, animated: true, completion: nil)
    }
}
