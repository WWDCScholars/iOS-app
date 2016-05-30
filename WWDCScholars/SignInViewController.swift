//
//  LoginViewController.swift
//  WWDCScholars 2016
//
//  Created by Sam Eckert on 15.4.16.
//  Copyright (c) 2016 WWDCScholars. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate, DragDropBehaviorDelegate {
    @IBOutlet private weak var passwordImageView: SpringImageView!
    @IBOutlet private weak var emailImageView: SpringImageView!
    @IBOutlet private weak var dialogView: SpringView!
    @IBOutlet private weak var signinButton: SpringButton!
    @IBOutlet private weak var emailTextField: DesignableTextField!
    @IBOutlet private weak var passwordTextField: DesignableTextField!
    @IBOutlet private weak var signUpButton: SpringButton!
    
    private var originalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
            let isAnonymous = user!.anonymous
            let userID = user!.uid
            
            print(isAnonymous)
            print(userID)
        }
        
        self.styleUI()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dialogView.animate()
        self.signUpButton.animate()
        
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
    
    // MARK: - Internal functions
    
    internal func dismissSignInViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func shakeSignInViewController() {
        self.dialogView.animation = "shake"
        self.dialogView.animate()
    }
    
    // MARK: - IBActions
    
    @IBAction func signinButtonPressed(sender: AnyObject) {
        if self.emailTextField.text == "" {
            //todo: show error -> no email
            self.shakeSignInViewController()
            return
        }
        if self.passwordTextField.text == "" {
            //todo: show error -> no password
            self.shakeSignInViewController()
            return
        }

        UserKit.sharedInstance.login(self.emailTextField.text!, password: self.passwordTextField.text!) { error in
            if error == nil {
                //todo "Logged in" dialog instead of loggin in again!
                self.dismissSignInViewController()
            } else {
                self.shakeSignInViewController()
            }
        }
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let url = NSURL(string: "http://wwdcscholarsform.herokuapp.com/addscholar")
        let viewController = SignUpSafariViewController(URL: url!)
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dialogView.animation = "zoomOut"
        self.dialogView.animate()
        
        self.signUpButton.animation = "zoomOut"
        self.signUpButton.animate()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func scrollViewPressed(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - DragDropBehavior
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
