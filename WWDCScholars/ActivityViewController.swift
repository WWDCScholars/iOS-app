//
//  ActivityViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

internal final class ActivityViewController: TWTRTimelineViewController {

    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.configureTwitterDataSource()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        let composeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.openTweetComposer))
        self.navigationItem.rightBarButtonItem = composeBarButtonItem
    }
    
    private func configureUI() {
        self.title = "Activity"
        self.showTweetActions = true
    }
    
    // MARK: - Private functions
    
    private func configureTwitterDataSource() {
        let client = TWTRAPIClient()
        let query = "#WWDCScholars OR from:@tim_cook OR from:@cue OR from:@jgeleynse OR from:@pschiller OR from:@AngelaAhrendts OR from:@EEhare"
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: client)
        self.dataSource = dataSource
    }
    
    // MARK: - Actions
    
    internal func openTweetComposer() {
        let composer = TWTRComposer()
        composer.setText("#WWDCScholars")
        composer.show(from: self) { _ in }
    }
}
