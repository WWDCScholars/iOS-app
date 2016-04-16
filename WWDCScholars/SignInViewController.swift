//
//  LoginViewController.swift
//  WWDC Scholars 2015
//
//  Created by Nikhil D'Souza on 5/25/15.
//  Copyright (c) 2015 WWDC-Scholars. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, DragDropBehaviorDelegate {
    
   
    @IBOutlet weak var passwordImageView: SpringImageView!
    @IBOutlet weak var emailImageView: SpringImageView!
    
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    var originalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        dialogView.animate()
        if UIScreen.mainScreen().bounds.size.height == 480 {
            dialogView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }
    }
    
    // MARK: Button
    @IBAction func signupButtonPressed(sender: AnyObject){
      /*  PFUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text, block: { (user,error) in
            if error != nil {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
                //                var alert = UIAlertView(title: "Error", message: "There was a problem with the username and password you have entered. Please try again.", delegate: nil, cancelButtonTitle: "Ok")
                //                alert.show()
            } else {
                self.passwordTextField.text = nil
                self.emailTextField.text = nil
                
                self.dialogView.animation = "zoomOut"
                self.dialogView.animate()
                self.performSegueWithIdentifier("edit", sender: self)
                //self.dismissViewControllerAnimated(true, completion: nil)
            }
        })*/
        
        print("Pressed Login")
    }

    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "zoomOut"
        dialogView.animate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    @IBAction func scrollViewPressed(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-user-active")
            emailImageView.animate()
        }
        else {
            emailImageView.image = UIImage(named: "icon-user")
        }
        
        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-key-active")
            passwordImageView.animate()
        }
        else {
            passwordImageView.image = UIImage(named: "icon-key")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-user")
        passwordImageView.image = UIImage(named: "icon-key")
    }
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
