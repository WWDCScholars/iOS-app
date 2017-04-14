//
//  ActivityViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ActivityViewController: UIViewController {
    
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
        self.title = "Activity"
    }
    
}
