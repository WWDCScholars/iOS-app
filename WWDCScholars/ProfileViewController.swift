//
//  ProfileViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 16/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ProfileViewController: UIViewController {
    
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
        self.title = "Profile"
    }
    
}
