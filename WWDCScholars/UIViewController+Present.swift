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
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.scholarId = scholarId
        profileViewController.modalPresentationStyle = .pageSheet
        self.present(profileViewController, animated: true, completion: nil)
    }
}
