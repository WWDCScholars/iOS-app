//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet private weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Chat"
    
        self.sendButton.applyInactiveChatButtonStyle()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
