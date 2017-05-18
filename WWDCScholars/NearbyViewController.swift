//
//  NearbyViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import MapKit

internal final class NearbyViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView?
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        
    }
    
    private func configureUI() {
        self.title = "Nearby"
    }
}
