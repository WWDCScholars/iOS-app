//
//  NearMeViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 03.04.17.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum updateType {
    case none
    case locationOnly
    case locationAndHeading
}

class NearMeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    fileprivate let locationManager = CLLocationManager()
  //  fileprivate var myLocation: CLLocationCoordinate2D?
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self as CLLocationManagerDelegate
        // Do any additional setup after loading the view.
        setupMap()
    }
    
    func setupMap(){
        
        let locateButton = UIButton(type: .custom)
        locateButton.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: UIScreen.main.bounds.height - 160, width: 33, height: 33)
        locateButton.setImage(UIImage(named: "locationButton"), for: UIControlState())
        locateButton.addTarget(self, action: #selector(NearMeViewController.locationButtonTapped), for: .touchUpInside)
        locateButton.layer.shadowOpacity = 0.5
        locateButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        locateButton.layer.shadowRadius = 2.0
        locateButton.applyRoundedCorners()
        locateButton.backgroundColor = UIColor.scholarsPurpleColor()
        self.mapView.addSubview(locateButton)

        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        
        let sanJose = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.3297201, -121.8896298), MKCoordinateSpanMake(0.08, 0.16))
        mapView.setRegion(sanJose, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationButtonTapped(){
        // This will check wether the view is currently tracking location, location + heading or nothing. Will implement later.
        
        
        serviceRequest()
    }
    
    func serviceRequest(){
    
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
                self.locationManager.startUpdatingHeading()
                startLocationTracking()
                zoomMap()

            }
        }

    
    }
    
    func zoomMap(){

        // ONLY LOCATION, NO HEADING
        
        
     /*   let zoomRegion = MKCoordinateRegionMakeWithDistance(userLocation!, 800, 800)
        self.mapView.setRegion(zoomRegion, animated: true)
        
      */
        /*  let mapCamera = MKMapCamera()
         let cameraLocation = CLLocationCoordinate2D(latitude: (self.mapView.userLocation.coordinate.latitude), longitude: (self.mapView.userLocation.coordinate.longitude)-0.000000000000107)
         mapCamera.centerCoordinate = cameraLocation
         mapCamera.pitch = 53
         mapCamera.altitude = 1500*/
        
    }
    func startLocationTracking(){
        self.locationManager.startUpdatingLocation()
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locationManager.location?.coordinate
        self.mapView.setCenter(userLocation!, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        let timer = Timer(fireAt: Date.init(timeIntervalSinceNow: 0), interval: 5, target: self, selector: #selector(NearMeViewController.startLocationTracking), userInfo: nil, repeats: false)
        timer.fire()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = locationManager.heading?.trueHeading
        let mapCamera = MKMapCamera(lookingAtCenter: self.mapView.userLocation.coordinate , fromDistance: 2000, pitch: 53, heading: heading!)
        self.mapView.setCamera(mapCamera, animated: true)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
