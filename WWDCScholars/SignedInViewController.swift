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
    @IBOutlet fileprivate weak var dialogView: SpringView!

    fileprivate var originalCenter: CGPoint!
    
    var delegate: EditDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        
        if UIScreen.main.bounds.size.height == 480.0 {
            self.dialogView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.dialogView.animate()
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.originalCenter = self.view.center
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        self.dialogView.animation = "zoomOut"
        self.dialogView.animate()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
        self.delegate?.presentEditDetailsViewController()
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        UserKit.sharedInstance.logout()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - DragDropBehavior
    
    func dragDropBehavior(_ behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismiss(animated: true, completion: nil)
    }
}
