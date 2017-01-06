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
    @IBOutlet fileprivate weak var dialogView: SpringView!
    @IBOutlet fileprivate weak var signinButton: SpringButton!
    @IBOutlet fileprivate weak var emailTextField: DesignableTextField!
    @IBOutlet fileprivate weak var passwordTextField: DesignableTextField!
    @IBOutlet fileprivate weak var signUpButton: SpringButton!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var blurView: UIView!
    
    fileprivate var originalCenter: CGPoint!
    fileprivate var tapSoundEffect: AVAudioPlayer!
    fileprivate var session = AVAudioSession.sharedInstance()
    
    var delegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard(_:)))
        self.blurView.addGestureRecognizer(gestureRecognizer)
        
        self.styleUI()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            let isAnonymous = user!.isAnonymous
            let userID = user!.uid
            
            print(isAnonymous)
            print(userID)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dialogView.animate()
        self.signUpButton.animate()
        
        if UIScreen.main.bounds.size.height == 480.0 {
            self.dialogView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.originalCenter = self.view.center
    }
    
    fileprivate func animateSignInButton(_ hidden: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.signinButton.alpha = CGFloat(!hidden)
            self.activityIndicator.alpha = CGFloat(hidden)
        })
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Internal functions
    
    internal func dismissSignInViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func shakeSignInViewController() {
        self.dialogView.animation = "shake"
        self.dialogView.animate()
    }
    
    internal func dismissKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func signinButtonPressed(_ sender: AnyObject) {
        self.animateSignInButton(true)
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            self.shakeSignInViewController()
            self.animateSignInButton(false)

            return
        }
        
        UserKit.sharedInstance.login(self.emailTextField.text!.lowercased(), password: self.passwordTextField.text!) { error in
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
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        let url = Foundation.URL(string: "http://wwdcscholars.herokuapp.com")
        let viewController = SignUpSafariViewController(url: url!)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dialogView.animation = "zoomOut"
        self.dialogView.animate()
        
        self.signUpButton.animation = "zoomOut"
        self.signUpButton.animate()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scrollViewPressed(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - Private functions
    
    fileprivate func playConfirmationSound(){
        let path = Bundle.main.path(forResource: "loginSuccessful.aif", ofType: nil)!
        let url = Foundation.URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.tapSoundEffect = sound
            self.tapSoundEffect.volume = 0.1
            sound.play()
            print("Sound played")
        } catch {
            print("Failed to load confirmation sound file")
        }
    }
    
    // MARK: - DragDropBehavior
    
    func dragDropBehavior(_ behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismiss(animated: true, completion: nil)
    }
}















































