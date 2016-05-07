//
//  EditProfileTableViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet private weak var screenshotCollectionView: UICollectionView!
    @IBOutlet private weak var profileImageButton: UIButton!
    @IBOutlet private weak var firstNameTextField: FloatLabelTextField!
    @IBOutlet private weak var secondNameTextField: FloatLabelTextField!
    @IBOutlet private weak var ageTextField: FloatLabelTextField!
    @IBOutlet private weak var bioTextView: FloatLabelTextView!
    @IBOutlet private weak var emailTextField: FloatLabelTextField!
    @IBOutlet private weak var twitterTextField: FloatLabelTextField!
    @IBOutlet private weak var facebookTextField: FloatLabelTextField!
    @IBOutlet private weak var githubTextField: FloatLabelTextField!
    @IBOutlet private weak var linkedinTextField: FloatLabelTextField!
    @IBOutlet private weak var websiteTextField: FloatLabelTextField!
    @IBOutlet private weak var appStoreTextField: FloatLabelTextField!
    @IBOutlet private weak var youtubeTextField: FloatLabelTextField!
    @IBOutlet private weak var appGithubTextField: FloatLabelTextField!
    
    private let numberOfScreenshots = 4
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileTableViewController.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
        
        self.styleUI()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.firstNameTextField:
            self.secondNameTextField.becomeFirstResponder()
        case self.secondNameTextField:
            self.ageTextField.becomeFirstResponder()
        case self.emailTextField:
            self.twitterTextField.becomeFirstResponder()
        case self.twitterTextField:
            self.facebookTextField.becomeFirstResponder()
        case self.facebookTextField:
            self.githubTextField.becomeFirstResponder()
        case self.githubTextField:
            self.linkedinTextField.becomeFirstResponder()
        case self.linkedinTextField:
            self.websiteTextField.becomeFirstResponder()
        case self.websiteTextField:
            self.appStoreTextField.becomeFirstResponder()
        case self.appStoreTextField:
            self.youtubeTextField.becomeFirstResponder()
        case self.youtubeTextField:
            self.appGithubTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }
        
        return true
    }
    
    // MARK: - UI
    
    internal func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func styleUI() {
        self.title = "Edit Profile"
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        
        self.profileImageButton.imageView!.layer.cornerRadius = self.profileImageButton.frame.width / 2
    }
    
    // MARK: - IBActions
    
    @IBAction func uploadProfileImageButtonTapped(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Update Profile Image", message: nil, preferredStyle: .ActionSheet)
        
        let uploadAction = UIAlertAction(title: "Photo Library", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(uploadAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension EditProfileTableViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfScreenshots
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("screenshotUploadCollectionViewCell", forIndexPath: indexPath) as! ScreenshotUploadCollectionViewCell
        
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageButton.contentMode = .ScaleAspectFit
            self.profileImageButton.setImage(pickedImage, forState: .Normal)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}