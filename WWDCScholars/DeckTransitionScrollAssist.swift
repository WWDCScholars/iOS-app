//
//  DeckTransitionScrollAssist.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 25/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
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
		//This behaviour is default in the new version of DeckTransition?
		return
    }
}
