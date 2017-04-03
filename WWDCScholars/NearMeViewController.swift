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

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        self.mapView.mapType = MKMapType.HybridFlyover
        
        
        let world = MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.783423, 9.181502), MKCoordinateSpanMake(50, 100))
        
        let stuttgart = MKCoordinateRegionMake(CLLocationCoordinate2DMake(48.783423, 9.181502), MKCoordinateSpanMake(0.08, 0.16))
        
        mapView.setRegion(world, animated: true)
        
        
        let delay = 3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {

            // Just testing things out with Stuttgart here ;) -Sam c:
            self.mapView.setRegion(stuttgart, animated: true)
            
        }
        
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
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
