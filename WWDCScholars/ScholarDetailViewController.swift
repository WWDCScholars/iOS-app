//
//  ScholarDetailViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import MapKit

class ScholarDetailViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageViewBackground: UIView!
    
    var currentScholar: Scholar?
    
    override func viewDidLoad() {
        self.styleUI()
        self.updateUI()
        self.configureMap()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.profileImageViewBackground.applyRoundedCorners()
        self.profileImageView.applyRoundedCorners()
        
        self.profileImageView.clipsToBounds = true
    }
    
    // MARK: - Private functions
    
    private func configureMap() {
        self.mapView.userInteractionEnabled = false
        
        let camera = MKMapCamera()
        camera.altitude = 7500
        camera.centerCoordinate.latitude = currentScholar!.location.latitude
        camera.centerCoordinate.longitude = currentScholar!.location.longitude
        
        self.mapView.setCamera(camera, animated: false)
    }
    
    private func updateUI() {
        self.title = currentScholar?.fullName
        
        self.locationLabel.text = currentScholar?.location.name
        self.nameLabel.text = currentScholar?.firstName
        self.profileImageView.af_setImageWithURL(NSURL(string: currentScholar!.profilePicURL)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
    }
}
