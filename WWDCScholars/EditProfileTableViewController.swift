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
    
    private let numberOfScreenshots = 4
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileTableViewController.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
        
        self.styleUI()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
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
        let actionSheet = UIAlertController(title: "Upload Profile Image", message: nil, preferredStyle: .ActionSheet)
        
        let uploadAction = UIAlertAction(title: "Import from photo library", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let takePhotoAction = UIAlertAction(title: "Take new photo", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
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