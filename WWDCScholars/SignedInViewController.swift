//
//  SignedInViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 03/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

protocol EditDetailsDelegate {
    func presentEditDetailsViewController()
}

class SignedInViewController: UIViewController, DragDropBehaviorDelegate {
    @IBOutlet private weak var dialogView: SpringView!

    private var originalCenter: CGPoint!
    
    var delegate: EditDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.dialogView.animate()
        
        if UIScreen.mainScreen().bounds.size.height == 480.0 {
            self.dialogView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.originalCenter = self.view.center
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dialogView.animation = "zoomOut"
        self.dialogView.animate()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.delegate?.presentEditDetailsViewController()
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        UserKit.sharedInstance.logout()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - DragDropBehavior
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
