//
//  LocationSelectViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSelectedDelegate {
    func updateLocation(location: CLLocationCoordinate2D)
}

class LocationSelectViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    @IBOutlet private weak var mapView: MKMapView!
    
    private var searchController: UISearchController!
    private var annotation: MKAnnotation!
    private var localSearchRequest: MKLocalSearchRequest!
    private var localSearch: MKLocalSearch!
    private var pointAnnotation: MKPointAnnotation!
    private var pinAnnotationView: MKPinAnnotationView!
    
    var passedLocation: CLLocationCoordinate2D?
    var delegate: LocationSelectedDelegate?
    
    override func viewDidLoad() {
        self.addAnnotation(self.passedLocation)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LocationSelectViewController.longPressGestureActivated(_:)))
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Annotations
    
    func mapView(aMapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        pinView.pinTintColor = UIColor.scholarsPurpleColor()
        
        return pinView
    }
    
    // MARK: - Internal functions
    
    internal func longPressGestureActivated(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            let locationInView = gestureRecognizer.locationInView(self.mapView)
            let pinCoordinates = self.mapView.convertPoint(locationInView, toCoordinateFromView: self.mapView)
            
            self.addAnnotation(pinCoordinates)
        }
    }
    
    internal func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        searchBar.resignFirstResponder()
        
        self.localSearchRequest = MKLocalSearchRequest()
        self.localSearchRequest.naturalLanguageQuery = searchBar.text
        self.localSearch = MKLocalSearch(request: self.localSearchRequest)
        self.localSearch.startWithCompletionHandler {(localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Location not found", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
            
            let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude,longitude: localSearchResponse!.boundingRegion.center.longitude)
            self.addAnnotation(coordinates)
        }
    }
    
    // MARK: - Private functions
    
    private func addAnnotation(coordinates: CLLocationCoordinate2D?) {
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
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.delegate?.updateLocation(self.mapView.annotations.first!.coordinate)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.presentViewController(self.searchController, animated: true, completion: nil)
    }
}
