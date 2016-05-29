//
//  SignUpSafariViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 06.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import SafariServices

class SignUpSafariViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = UIColor.scholarsPurpleColor()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}
