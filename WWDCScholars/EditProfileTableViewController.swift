//
//  EditProfileTableViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

enum ImageUploadType {
    case profile
    case screenshot
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
    @IBOutlet fileprivate weak var screenshotCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var profileImageButton: UIButton!
    @IBOutlet fileprivate weak var locationChangeButton: UIButton!
    @IBOutlet fileprivate weak var firstNameTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var secondNameTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var ageTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var locationTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var emailTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var bioTextView: UITextView!
    @IBOutlet fileprivate weak var twitterTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var facebookTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var githubTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var linkedinTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var websiteTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var appStoreTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var youtubeTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var appGithubTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var iMessageTextField: FloatLabelTextField!
    @IBOutlet fileprivate weak var appStoreSubmissionTextField: FloatLabelTextField!
    
    fileprivate var profilePic: UIImage? = nil,
    firstName: String? = nil,
    lastName: String? = nil,
    email: String? = nil,
    birthday: Date? = nil,
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
    shortBio: String? = nil,
    updatedScreenshots: [UIImage?] = [nil, nil, nil, nil]
    
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate let locationManager = CLLocationManager()
    fileprivate let bioMaxLength = 300
    
    fileprivate var currentScholar: Scholar?
    fileprivate var myLocation: CLLocationCoordinate2D?
    fileprivate var screenshotUploadIndex = 0
    fileprivate var imageUploadType: ImageUploadType = .profile
    fileprivate var screenshots: [UIImage?] = [nil, nil, nil, nil]
    fileprivate var datePicker: UIDatePicker!
    fileprivate var hasData = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.hasData {
            self.populateFields()
        }
        
        self.configureDatePicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: LocationSelectViewController.self) {
            let navigationController = segue.destination as! UINavigationController
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
    
    fileprivate func styleUI() {
        self.title = "Edit Profile"
        
        self.locationChangeButton.setTitleColor(UIColor.scholarsPurpleColor(), for: UIControlState())
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.navigationBar.isTranslucent = false
        
        self.imagePicker.navigationBar.barTintColor = UIColor.scholarsPurpleColor()
        
        self.profileImageButton.imageView?.contentMode = .scaleAspectFill
        self.profileImageButton.imageView!.layer.cornerRadius = self.profileImageButton.frame.width / 2
    }
    
    fileprivate func configureDatePicker() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date.dateMinusYears(10)
        self.datePicker.minimumDate = Date.dateMinusYears(100)
        self.ageTextField.inputView = self.datePicker
        
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 44.0)
        toolBar.tintColor = UIColor.gray
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditProfileTableViewController.dismissDatePicker))
        doneButton.tintColor = UIColor.scholarsPurpleColor()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([space, doneButton], animated: false)
        self.ageTextField.inputAccessoryView = toolBar
        
        if let date = self.currentScholar?.birthday {
            self.datePicker.setDate(date as Date, animated: false)
        }
    }
    
    // MARK: - Internal functions
    
    internal func dismissDatePicker() {
        self.ageTextField.text = DateManager.shortDateStringFromDate(self.datePicker.date)
        self.ageTextField.resignFirstResponder()
    }
    
    internal func setScholar(_ id: String) {
        self.currentScholar = DatabaseManager.sharedInstance.scholarForId(id)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentScholar?.location == nil {
            self.myLocation = manager.location?.coordinate
            self.updateLocation(self.myLocation!)
        }
    }
    
    internal func updateLocation(_ location: CLLocationCoordinate2D) {
        LocationManager.sharedInstance.getLocationDetails(withParameter: location, completion: {(locationDetails) -> Void in
            self.locationTextField.text = ("\(locationDetails.0), \(locationDetails.1)")
            self.myLocation = location
            
            let newLoc = Location(name: "\(locationDetails.0), \(locationDetails.1)", longitude: location.longitude, latitude: location.latitude)
            self.location = newLoc
            
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    internal func importNewScreenshot(_ index: Int) {
        self.imagePicker.sourceType = .photoLibrary
        self.imageUploadType = .screenshot
        self.screenshotUploadIndex = index
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    internal func presentActionSheet(_ index: Int) {
        if self.screenshots[index] != nil {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let removeAction = UIAlertAction(title: "Remove Screenshot", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.screenshots[index] = nil
                self.screenshotCollectionView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(removeAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private functions
    
    fileprivate func populateFields() {
        guard self.currentScholar != nil else {
            return
        }
        
        if (self.currentScholar!.latestBatch.batchWWDC != .WWDC2016) {
            self.appStoreSubmissionTextField.isEnabled = false
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
        
        for (index, screenshot) in self.currentScholar!.latestBatch.screenshots.enumerated() {
            Alamofire.request(screenshot).responseImage { response in
                if let image = response.result.value {
                    self.screenshots[index] = image
                    
                    self.screenshotCollectionView.reloadData()
                }
            }
        }
        
        if let imageURL = Foundation.URL(string: self.currentScholar!.latestBatch.profilePic) {
            
            self.profileImageButton.af_setImage(for: .normal, url: imageURL, placeholderImage: UIImage(named: "placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: nil)
            
          //  self.profileImageButton.af_setImageForState(UIControlState(), URL: imageURL, placeHolderImage: UIImage(named: "placeholder"), progress: nil, progressQueue: DispatchQueue.main, completion: nil)
        }
        
        self.hasData = true
    }
    
    fileprivate func updateProfileImageIfFaceDetected(_ importedImage: UIImage) {
        let image = CIImage(cgImage: importedImage.cgImage!)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
        
        let faces = faceDetector?.features(in: image)
        
        if faces?.first != nil {
            let croppedImage = UIImage.cropImageToSquare(importedImage)
            self.profileImageButton.setImage(croppedImage, for: UIControlState())
        } else {
            self.presentConfirmationCheck(importedImage)
        }
    }
    
    fileprivate func presentConfirmationCheck(_ importedImage: UIImage) {
        let alertController = UIAlertController(title: "No face detected", message: "Are you sure this is an image of you? We strongly encourage profile-style images.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "I'm Sure!", style: .default) { (action) in
            let croppedImage = UIImage.cropImageToSquare(importedImage)
            self.profileImageButton.setImage(croppedImage, for: UIControlState())
            self.profilePic = importedImage
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }


    fileprivate func validateTextFields() -> ValidationIssueType {
        let validationIssue: ValidationIssueType = .None
       
        /*
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
        */
        return validationIssue
    }

    
    // MARK: - IBActions
    
    @IBAction func uploadProfileImageButtonTapped(_ sender: AnyObject) {
        self.imageUploadType = .profile
        
        let actionSheet = UIAlertController(title: "Update Profile Image", message: nil, preferredStyle: .actionSheet)
        
        let uploadAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(uploadAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        let validationResult = self.validateTextFields()
        
        if validationResult == .None {
            let alertController = UIAlertController(title: "Password", message: "Please enter your password to confirm your changes", preferredStyle: .alert)
            
            alertController.addTextField { (textField) -> Void in
                textField.isSecureTextEntry = true
                textField.placeholder = "Password"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                if self.currentScholar?.firstName != self.firstNameTextField.text {
                    self.firstName = self.firstNameTextField.text
                }
                
                if self.currentScholar?.lastName != self.secondNameTextField.text {
                    self.lastName = self.secondNameTextField.text
                }
                
                if self.currentScholar?.email != self.emailTextField.text {
                    self.email = self.emailTextField.text
                }
                
                if self.currentScholar?.birthday != self.datePicker.date {
                    self.birthday = self.datePicker.date
                }
                
                if self.currentScholar?.latestBatch.youtubeLink != self.youtubeTextField.text {
                    self.videoLink = self.youtubeTextField.text
                }
                
                if self.currentScholar?.latestBatch.githubLink != self.appGithubTextField.text {
                    self.githubLinkApp = self.appGithubTextField.text
                }
                
                if self.currentScholar?.twitterURL != self.twitterTextField.text {
                    self.twitter = self.twitterTextField.text
                }
                
                if self.currentScholar?.facebookURL != self.facebookTextField.text {
                    self.facebook = self.facebookTextField.text
                }
                if self.currentScholar?.githubURL != self.githubTextField.text {
                    self.github = self.githubTextField.text
                }
                if self.currentScholar?.linkedInURL != self.linkedinTextField.text {
                    self.linkedin = self.linkedinTextField.text
                }
                if self.currentScholar?.iTunesURL != self.appStoreTextField.text {
                    self.itunes = self.appStoreTextField.text
                }
                if self.currentScholar?.iMessage != self.iMessageTextField.text {
                    self.iMessage = self.iMessageTextField.text
                }
                if self.currentScholar?.shortBio != self.bioTextView.text {
                    self.shortBio = self.bioTextView.text
                }
                
                let alert = UIAlertController(title: "Updating details...", message: nil, preferredStyle: .alert);
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                activityIndicator.frame = activityIndicator.frame.offsetBy(dx: 8, dy: (alert.view.bounds.height - activityIndicator.frame.height)/2);
                activityIndicator.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
                activityIndicator.startAnimating();
                alert.view.addSubview(activityIndicator);
                
                ScholarsKit.sharedInstance.updateScholarData(UserKit.sharedInstance.scholarId!,
                    password: alertController.textFields?.first?.text ?? "",
                    profilePic: self.profilePic,
                    screenshotOne: self.updatedScreenshots[0],
                    screenshotTwo: self.updatedScreenshots[1],
                    screenshotThree: self.updatedScreenshots[2],
                    screenshotFour: self.updatedScreenshots[3],
                    firstName: self.firstName,
                    lastName: self.lastName,
                    email: self.email,
                    birthday: self.birthday,
                    location: self.location,
                    videoLink: self.videoLink,
                    githubLinkApp: self.githubLinkApp,
                    twitter: self.twitter,
                    facebook: self.facebook,
                    github: self.github,
                    linkedin: self.linkedin,
                    website: self.website,
                    itunes: self.itunes,
                    iMessage: self.iMessage,
                shortBio: self.shortBio) { error, message in
                    
                    alert.dismiss(animated: true) {
                        if error != nil {
                            let alertController = UIAlertController(title: "Error", message: "An error occured. Make sure you have a working internet connection and try again later or contact us. Error code: \(error!.code.description)", preferredStyle: .alert)
                            
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            
                            alertController.addAction(confirmAction)
                            
                            
                            self.present(alertController, animated: true, completion: nil)
                        }else {
                            let alertController = UIAlertController(title: "Sucess!", message: message, preferredStyle: .alert)
                            
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                                self.cancelButtonTapped(self)
                            })
                            alertController.addAction(confirmAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                
                self.present(alert, animated: true, completion: nil)
                
            })
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Invalid Details", message: validationResult.rawValue, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectLocationButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: String(describing: LocationSelectViewController.self), sender: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension EditProfileTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotUploadCollectionViewCell", for: indexPath) as! ScreenshotUploadCollectionViewCell
        
        cell.tag = indexPath.item
        cell.iconView.isHidden = self.screenshots[indexPath.item] != nil
        cell.delegate = self
        
        if indexPath.item < self.screenshots.count {
            cell.uploadButton.setImage(self.screenshots[indexPath.item], for: UIControlState())
        }
        
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            switch self.imageUploadType {
            case .profile:
                self.updateProfileImageIfFaceDetected(pickedImage)
            case .screenshot:
                self.screenshots[self.screenshotUploadIndex] = pickedImage
                self.updatedScreenshots[self.screenshotUploadIndex] = pickedImage
                self.screenshotCollectionView.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension EditProfileTableViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let character = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(character, "\\b")
        
        if text.rangeOfCharacter(from: CharacterSet.newlines) != nil {
            textView.resignFirstResponder()
            
            return false
        } else if textView.text.length - range.length + text.length > self.bioMaxLength {
            return isBackSpace == -92
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.footerView(forSection: IndexPath(row: 0, section: 1).section)?.textLabel?.text = "Bio descriptions are limited to \(self.bioMaxLength) characters (\(self.bioMaxLength - textView.text.length) remaining)"
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
