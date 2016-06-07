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
import AVFoundation

protocol SignInDelegate {
    func userSignedIn()
}

class SignInViewController: UIViewController, UITextFieldDelegate, DragDropBehaviorDelegate {
    @IBOutlet private weak var dialogView: SpringView!
    @IBOutlet private weak var signinButton: SpringButton!
    @IBOutlet private weak var emailTextField: DesignableTextField!
    @IBOutlet private weak var passwordTextField: DesignableTextField!
    @IBOutlet private weak var signUpButton: SpringButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var blurView: UIView!
    
    private var originalCenter: CGPoint!
    private var tapSoundEffect: AVAudioPlayer!
    private var session = AVAudioSession.sharedInstance()
    
    var delegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard(_:)))
        self.blurView.addGestureRecognizer(gestureRecognizer)
        
        self.styleUI()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
            let isAnonymous = user!.anonymous
            let userID = user!.uid
            
            print(isAnonymous)
            print(userID)
        }
        
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
    
    private func animateSignInButton(hidden: Bool) {
        UIView.animateWithDuration(0.2, animations: {
            self.signinButton.alpha = CGFloat(!hidden)
            self.activityIndicator.alpha = CGFloat(hidden)
        })
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
    
    internal func dismissKeyboard(gestureRecognizer: UIGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func signinButtonPressed(sender: AnyObject) {
        self.animateSignInButton(true)
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            self.shakeSignInViewController()
            self.animateSignInButton(false)

            return
        }
        
        UserKit.sharedInstance.login(self.emailTextField.text!, password: self.passwordTextField.text!) { error in
            if error == nil {
                self.playConfirmationSound()
                delay(1) {
                self.dismissSignInViewController()
                }
                self.delegate?.userSignedIn()
            } else {
                self.animateSignInButton(false)
                self.shakeSignInViewController()
            }
        }
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let url = NSURL(string: "http://wwdcscholars.herokuapp.com")
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
    
    // MARK: - Private functions
    
    private func playConfirmationSound(){
        let path = NSBundle.mainBundle().pathForResource("loginSuccessful.aif", ofType: nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            self.tapSoundEffect = sound
            self.tapSoundEffect.volume = 0.1
            sound.play()
            print("Sound played")
        } catch {
            print("Failed to load confirmation sound file")
        }
    }
    
    // MARK: - DragDropBehavior
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}















































