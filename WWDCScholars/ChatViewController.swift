//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: JSQMessagesViewController {
    private var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = "Andrew Walker"
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Chat"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}