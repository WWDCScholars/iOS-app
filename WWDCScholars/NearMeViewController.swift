//
//  NearMeViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 03.04.17.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit

class NearMeViewController: UIViewController, MKMapViewDelegate {

    fileprivate let locationManager = CLLocationManager()
    fileprivate var myLocation: CLLocationCoordinate2D?
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     configureMap()
         zoomMap()
      /*  let world = MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.783423, 9.181502), MKCoordinateSpanMake(50, 100))
        
        let stuttgart = MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.783423, 9.181502), MKCoordinateSpanMake(0.08, 0.16))
        
        mapView.setRegion(stuttgart, animated: true)*/
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMap(){
        

        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        
        
            let locateButton = UIButton(type: .custom)
            locateButton.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: UIScreen.main.bounds.height - 160, width: 33, height: 33)
            locateButton.setImage(UIImage(named: "locationButton"), for: UIControlState())
            locateButton.addTarget(self, action: #selector(NearMeViewController.zoomMap), for: .touchUpInside)
            locateButton.layer.shadowOpacity = 0.5
            locateButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            locateButton.layer.shadowRadius = 2.0
            locateButton.applyRoundedCorners()
            locateButton.backgroundColor = UIColor.scholarsPurpleColor()
            
            self.mapView.addSubview(locateButton)
        
        
        let myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
        let zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 5000, 5000)
        self.mapView.setRegion(zoomRegion, animated: true)

        zoomMap()
    }
    
    
    func zoomMap(){
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
                let myLocation = self.mapView.userLocation.coordinate as CLLocationCoordinate2D
                let zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 5000, 5000)
                self.mapView.setRegion(zoomRegion, animated: true)
            }
        }

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
