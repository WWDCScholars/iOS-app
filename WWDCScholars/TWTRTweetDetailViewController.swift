//
//  TWTRTweetDetailViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 25/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

extension TWTRTweetDetailViewController: UIScrollViewDelegate, DeckTransitionScrollAssist {
    
    // MARK: - Public Functions
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateDeckTransition(for: scrollView)
    }
}
