//
//  UIViewController+Present.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 26/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension UIViewController {
    
    // MARK: - Functions
    
    func presentProfileViewController(scholarId: CKRecord.ID) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let profileViewController = navigationController.viewControllers.first as! ProfileViewController
        profileViewController.scholarId = scholarId
        profileViewController.modalPresentationStyle = .pageSheet
        self.present(navigationController, animated: true, completion: nil)
    }
}
