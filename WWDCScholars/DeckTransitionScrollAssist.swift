//
//  DeckTransitionScrollAssist.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 25/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import DeckTransition

internal protocol DeckTransitionScrollAssist: class {
    func updateDeckTransition(for scrollView: UIScrollView)
}

internal extension DeckTransitionScrollAssist where Self: UIViewController {
    
    // MARK: - Internal Functions
    
    internal func updateDeckTransition(for scrollView: UIScrollView) {
        guard let delegate = self.transitioningDelegate as? DeckTransitioningDelegate else {
            return
        }
        
        let contentOffset = scrollView.contentOffset
        if contentOffset.y > 0.0 {
            scrollView.bounces = true
            delegate.isDismissEnabled = false
        } else {
            if scrollView.isDecelerating {
                self.view.transform = CGAffineTransform(translationX: 0.0, y: -contentOffset.y)
                scrollView.transform = CGAffineTransform(translationX: 0.0, y: contentOffset.y)
            } else {
                scrollView.bounces = false
                delegate.isDismissEnabled = true
            }
        }
    }
}
