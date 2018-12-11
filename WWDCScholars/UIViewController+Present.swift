//
//  UIViewController+Present.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 26/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import DeckTransition

internal extension UIViewController {
    
    // MARK: - Internal Functions
    
    internal func presentProfileViewController(scholarId: UUID) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.scholarId = scholarId
        let transitionDelegate = DeckTransitioningDelegate()
        profileViewController.transitioningDelegate = transitionDelegate
        profileViewController.modalPresentationStyle = .custom
        self.present(profileViewController, animated: true, completion: nil)
    }
}
