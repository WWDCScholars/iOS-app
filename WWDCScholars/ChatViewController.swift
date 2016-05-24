//
//  AlumniViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Chat"
    
        self.sendButton.applyInactiveChatButtonStyle()
    }
    
    private func configureUI() {
        self.addKeyboardObserver()
        
        self.messageTextField.addTarget(self, action: #selector(ChatViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - Private functions
    
    private func addKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Internal functions
    
    internal func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            let keyboardHeight = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height ?? 0.0
            self.containerViewBottomConstraint.constant = keyboardHeight - self.tabBarController!.tabBar.frame.height
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    internal func keyboardWillHide(notification: NSNotification) {
        self.containerViewBottomConstraint.constant = 0.0
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func viewTapped(sender: AnyObject) {
        self.messageTextField.resignFirstResponder()
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        self.messageTextField.text = ""
    }
}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    internal func textFieldDidChange(textField: UITextField) {
        self.messageTextField.text?.length > 0 ? self.sendButton.applyActiveChatButtonStyle() : self.sendButton.applyInactiveChatButtonStyle()
    }
}
