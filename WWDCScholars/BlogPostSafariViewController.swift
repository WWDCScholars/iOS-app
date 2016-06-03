//
//  BlogPostSafariViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 11.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import SafariServices

class BlogPostSafariViewController: SFSafariViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = UIColor.scholarsPurpleColor()
    }
}
