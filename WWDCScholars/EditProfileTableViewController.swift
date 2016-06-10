//
//  EditProfileTableViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

enum ImageUploadType {
    case Profile
    case Screenshot
}

enum ValidationIssueType: String {
    case Twitter = "Your Twitter profile URL doesn't seem to be valid."
    case Facebook = "Your Facebook profile URL doesn't seem to be valid."
    case GitHub = "Your GitHub profile URL doesn't seem to be valid"
    case LinkedIn = "Your LinkedIn profile URL doesn't seem to be valid"
    case YoutubeLink = "Your Youtube URL for your App Video doesn't seem to be valid, please don't use url shortener."
    case GithubApp = "Your Github URL for your App doesn't seem to be valid"
    case iTunes = "Your iTunes Developer Account url doesn't seem to be valid, please don't use url shortener"
    case FirstName = "Please enter your first name"
    case SecondName = "Please enter your second name"
    case None = ""
}

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, LocationSelectedDelegate, ScreenshotImportDelegate {
    @IBOutlet private weak var screenshotCollectionView: UICollectionView!
    @IBOutlet private weak var profileImageButton: UIButton!
    @IBOutlet private weak var locationChangeButton: UIButton!
    @IBOutlet private weak var firstNameTextField: FloatLabelTextField!
    @IBOutlet private weak var secondNameTextField: FloatLabelTextField!
    @IBOutlet private weak var ageTextField: FloatLabelTextField!
    @IBOutlet private weak var locationTextField: FloatLabelTextField!
    @IBOutlet private weak var emailTextField: FloatLabelTextField!
    @IBOutlet private weak var bioTextView: UITextView!
    @IBOutlet private weak var twitterTextField: FloatLabelTextField!
    @IBOutlet private weak var facebookTextField: FloatLabelTextField!
    @IBOutlet private weak var githubTextField: FloatLabelTextField!
    @IBOutlet private weak var linkedinTextField: FloatLabelTextField!
    @IBOutlet private weak var websiteTextField: FloatLabelTextField!
    @IBOutlet private weak var appStoreTextField: FloatLabelTextField!
    @IBOutlet private weak var youtubeTextField: FloatLabelTextField!
    @IBOutlet private weak var appGithubTextField: FloatLabelTextField!
    @IBOutlet private weak var iMessageTextField: FloatLabelTextField!
    @IBOutlet private weak var appStoreSubmissionTextField: FloatLabelTextField!
    
    private var profilePic: UIImage? = nil,
    screenshotOne: UIImage? = nil,
    screenshotTwo: UIImage? = nil,
    screenshotThree: UIImage? = nil,
    screenshotFour: UIImage? = nil,
    firstName: String? = nil,
    lastName: String? = nil,
    email: String? = nil,
    birthday: NSDate? = nil,
    location: Location? = nil,
    videoLink: String? = nil,
    githubLinkApp: String? = nil,
    twitter: String? = nil,
    facebook: String? = nil,
    github: String? = nil,
    linkedin: String? = nil,
    website: String? = nil,
    itunes: String? = nil,
    iMessage: String? = nil,
    shortBio: String? = nil
    
    private let imagePicker = UIImagePickerController()
    private let locationManager = CLLocationManager()
    private let bioMaxLength = 300
    
    private var currentScholar: Scholar?
    private var myLocation: CLLocationCoordinate2D?
    private var screenshotUploadIndex = 0
    private var imageUploadType: ImageUploadType = .Profile
    private var screenshots: [UIImage?] = [nil, nil, nil, nil]
    private var datePicker: UIDatePicker!
    private var hasData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileTableViewController.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.styleUI()
        self.populateFields()
        self.setScholar(UserKit.sharedInstance.scholarId ?? "unknown")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.hasData {
            self.populateFields()
        }
        
        self.configureDatePicker()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(LocationSelectViewController) {
            let navigationController = segue.destinationViewController as! UINavigationController
            let destinationViewController = navigationController.topViewController as! LocationSelectViewController
            destinationViewController.passedLocation = self.myLocation
            destinationViewController.delegate = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.textViewDidChange(self.bioTextView)
    }
    
    // MARK: - UI
    
    internal func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func styleUI() {
        self.title = "Edit Profile"
        
        self.locationChangeButton.setTitleColor(UIColor.scholarsPurpleColor(), forState: .Normal)
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.navigationBar.translucent = false
        
        self.imagePicker.navigationBar.barTintColor = UIColor.scholarsPurpleColor()
        
        self.profileImageButton.imageView?.contentMode = .ScaleAspectFill
        self.profileImageButton.imageView!.layer.cornerRadius = self.profileImageButton.frame.width / 2
    }
    
    private func configureDatePicker() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .Date
        self.datePicker.maximumDate = NSDate.dateMinusYears(10)
        self.datePicker.minimumDate = NSDate.dateMinusYears(100)
        self.ageTextField.inputView = self.datePicker
        
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 44.0)
        toolBar.tintColor = UIColor.grayColor()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(EditProfileTableViewController.dismissDatePicker))
        doneButton.tintColor = UIColor.scholarsPurpleColor()
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([space, doneButton], animated: false)
        self.ageTextField.inputAccessoryView = toolBar
        
        if let date = self.currentScholar?.birthday {
            self.datePicker.setDate(date, animated: false)
        }
    }
    
    // MARK: - Internal functions
    
    internal func dismissDatePicker() {
        self.ageTextField.text = DateManager.shortDateStringFromDate(self.datePicker.date)
        self.ageTextField.resignFirstResponder()
    }
    
    internal func setScholar(id: String) {
        self.currentScholar = DatabaseManager.sharedInstance.scholarForId(id)
    }
    
    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentScholar?.location == nil {
            self.myLocation = manager.location?.coordinate
            self.updateLocation(self.myLocation!)
        }
    }
    
    internal func updateLocation(location: CLLocationCoordinate2D) {
        LocationManager.sharedInstance.getLocationDetails(location, completion: {(locationDetails) -> Void in
            self.locationTextField.text = ("\(locationDetails.locality), \(locationDetails.country)")
            self.myLocation = location
            
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    internal func importNewScreenshot(index: Int) {
        self.imagePicker.sourceType = .PhotoLibrary
        self.imageUploadType = .Screenshot
        self.screenshotUploadIndex = index
        
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    internal func presentActionSheet(index: Int) {
        if self.screenshots[index] != nil {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let removeAction = UIAlertAction(title: "Remove Screenshot", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
                self.screenshots[index] = nil
                self.screenshotCollectionView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            actionSheet.addAction(removeAction)
            actionSheet.addAction(cancelAction)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private functions
    
    private func populateFields() {
        guard self.currentScholar != nil else {
            return
        }
        
        if (self.currentScholar!.latestBatch.batchWWDC != .WWDC2016) {
            self.appStoreSubmissionTextField.enabled = false
        }
        
        self.firstNameTextField.text = self.currentScholar?.firstName
        self.secondNameTextField.text = self.currentScholar?.lastName
        self.locationTextField.text = self.currentScholar?.location.name
        self.bioTextView.text = self.currentScholar?.shortBio
        self.emailTextField.text = self.currentScholar?.email
        self.twitterTextField.text = self.currentScholar?.twitterURL
        self.facebookTextField.text = self.currentScholar?.facebookURL
        self.githubTextField.text = self.currentScholar?.githubURL
        self.linkedinTextField.text = self.currentScholar?.linkedInURL
        self.websiteTextField.text = self.currentScholar?.websiteURL
        self.appStoreTextField.text = self.currentScholar?.iTunesURL
        self.appStoreSubmissionTextField.text = self.currentScholar?.latestBatch.appstoreSubmissionURL

        //App Links
        self.youtubeTextField.text = self.currentScholar?.latestBatch.youtubeLink
        self.appGithubTextField.text = self.currentScholar?.latestBatch.githubLink

        self.ageTextField.text = DateManager.shortDateStringFromDate(self.currentScholar!.birthday)
        self.iMessageTextField.text = self.currentScholar?.iMessage
        
        self.myLocation = CLLocationCoordinate2D(latitude: self.currentScholar!.location.latitude, longitude: self.currentScholar!.location.longitude)
        
        for (index, screenshot) in self.currentScholar!.latestBatch.screenshots.enumerate() {
            request(.GET, screenshot).responseImage { response in
                if let image = response.result.value {
                    self.screenshots[index] = image
                    
                    self.screenshotCollectionView.reloadData()
                }
            }
        }
        
        if let imageURL = NSURL(string: self.currentScholar!.latestBatch.profilePic) {
            self.profileImageButton.af_setImageForState(.Normal, URL: imageURL, placeHolderImage: UIImage(named: "placeholder"), progress: nil, progressQueue: dispatch_get_main_queue(), completion: nil)
        }
        
        self.hasData = true
    }
    
    private func updateProfileImageIfFaceDetected(importedImage: UIImage) {
        let image = CIImage(CGImage: importedImage.CGImage!)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
        
        let faces = faceDetector.featuresInImage(image)
        
        if faces.first != nil {
            let croppedImage = UIImage.cropImageToSquare(importedImage)
            self.profileImageButton.setImage(croppedImage, forState: .Normal)
        } else {
            self.presentConfirmationCheck(importedImage)
        }
    }
    
    private func presentConfirmationCheck(importedImage: UIImage) {
        let alertController = UIAlertController(title: "No face detected", message: "Are you sure this is an image of you? We strongly encourage profile-style images.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "I'm Sure!", style: .Default) { (action) in
            let croppedImage = UIImage.cropImageToSquare(importedImage)
            self.profileImageButton.setImage(croppedImage, forState: .Normal)
            self.profilePic = importedImage
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func validateTextFields() -> ValidationIssueType {
        var validationIssue: ValidationIssueType = .None
        
        if let text = self.facebookTextField.text where self.facebookTextField.text != "" {
            if !text.isValidFacebookLink() {
                validationIssue = .Facebook
            }
        }
        
        if let text = self.githubTextField.text where self.githubTextField.text != "" {
            if !text.isValidGitHubLink() {
                validationIssue = .GitHub
            }
        }
        
        if let text = self.twitterTextField.text where self.twitterTextField.text != "" {
            if !text.isValidTwitterLink() {
                validationIssue = .Twitter
            }
        }
        
        if let text = self.linkedinTextField.text where self.linkedinTextField.text != "" {
            if !text.isValidLinkedInLink() {
                validationIssue = .LinkedIn
            }
        }
        
    
        if let text = self.appStoreTextField.text where self.appStoreTextField.text != "" {
            if !text.isValidiTunesLink() {
                validationIssue = .iTunes
            }
        }
        
        if let text = self.appGithubTextField.text where self.appGithubTextField.text != "" {
            if !text.isValidGitHubLink() {
                validationIssue = .GithubApp
            }
        }
        
        if let text = self.youtubeTextField.text where self.youtubeTextField.text != "" {
            if !text.isValidyoutubeLink() {
                validationIssue = .YoutubeLink
            }
        }
        
        
        
        if self.firstNameTextField.text == "" {
            validationIssue = .FirstName
        }
        
        if self.secondNameTextField.text == "" {
            validationIssue = .SecondName
        }
        
        return validationIssue
    }
    
    // MARK: - IBActions
    
    @IBAction func uploadProfileImageButtonTapped(sender: AnyObject) {
        self.imageUploadType = .Profile
        
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
        let validationResult = self.validateTextFields()
        
        if validationResult == .None {
            let alertController = UIAlertController(title: "Password", message: "Please enter your password to confirm your changes", preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.secureTextEntry = true
                textField.placeholder = "Password"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .Default, handler: { _ in
                ScholarsKit.sharedInstance.updateScholarData(UserKit.sharedInstance.scholarId!, password: alertController.textFields?[0].text ?? "", profilePic: self.profilePic, screenshotOne: self.screenshotOne, screenshotTwo: self.screenshotTwo, screenshotThree: self.screenshotThree, screenshotFour: self.screenshotFour, firstName: self.firstName, lastName: self.lastName, email: self.email, birthday: self.birthday, location: self.location, videoLink: self.videoLink, githubLinkApp: self.githubLinkApp, twitter: self.twitter, facebook: self.facebook, github: self.github, linkedin: self.linkedin, website: self.website, itunes: self.itunes, iMessage: self.iMessage, shortBio: self.shortBio)
                
                
            })
            alertController.addAction(confirmAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            var password = ""
            let alertController = UIAlertController(title: "Invalid Details", message: validationResult.rawValue, preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                let textField = alertController.textFields?.first
                password = textField?.text ?? ""
            })
            alertController.addAction(confirmAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectLocationButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier(String(LocationSelectViewController), sender: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension EditProfileTableViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshots.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("screenshotUploadCollectionViewCell", forIndexPath: indexPath) as! ScreenshotUploadCollectionViewCell
        
        cell.tag = indexPath.item
        cell.iconView.hidden = self.screenshots[indexPath.item] != nil
        cell.delegate = self
        
        if indexPath.item < self.screenshots.count {
            cell.uploadButton.setImage(self.screenshots[indexPath.item], forState: .Normal)
        }
        
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            switch self.imageUploadType {
            case .Profile:
                self.updateProfileImageIfFaceDetected(pickedImage)
            case .Screenshot:
                self.screenshots[self.screenshotUploadIndex] = pickedImage
                
                self.screenshotCollectionView.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension EditProfileTableViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let character = text.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(character, "\\b")
        
        if text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()) != nil {
            textView.resignFirstResponder()
            
            return false
        } else if textView.text.length - range.length + text.length > self.bioMaxLength {
            return isBackSpace == -92
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        self.tableView.footerViewForSection(NSIndexPath(forRow: 0, inSection: 1).section)?.textLabel?.text = "Bio descriptions are limited to \(self.bioMaxLength) characters (\(self.bioMaxLength - textView.text.length) remaining)"
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileTableViewController: UITextFieldDelegate {
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
            self.iMessageTextField.becomeFirstResponder()
        case self.iMessageTextField:
            self.youtubeTextField.becomeFirstResponder()
        case self.youtubeTextField:
            self.appGithubTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }
        
        return true
    }
}