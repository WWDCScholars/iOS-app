//
//  EditDetailsViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 10.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class EditDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    // MARK: TextFields & TextViews
    @IBOutlet var nameTextField: FloatLabelTextField!
    @IBOutlet var ageTextField: FloatLabelTextField!
    @IBOutlet var cityCountryTextField: FloatLabelTextField!
    @IBOutlet var shortBioTextView: FloatLabelTextView!
    @IBOutlet var youtubeLinkTextField: FloatLabelTextField!
    @IBOutlet var githubLinkTextField: FloatLabelTextField!
    @IBOutlet var emailTextField: FloatLabelTextField!
    @IBOutlet var twitterTextField: FloatLabelTextField!
    @IBOutlet var facebookTextField: FloatLabelTextField!
    @IBOutlet var githubTextField: FloatLabelTextField!
    @IBOutlet var linkedinTextField: FloatLabelTextField!
    @IBOutlet var websiteTextField: FloatLabelTextField!
    @IBOutlet var appstoreTextField: FloatLabelTextField!
    
    // MARK: Buttons
    @IBOutlet var profilePhotoButton: UIButton!
    @IBOutlet var screenshot1Button: UIButton!
    @IBOutlet var screenshot2Button: UIButton!
    @IBOutlet var screenshot3Button: UIButton!
    @IBOutlet var screenshot4Button: UIButton!
    
    // MARK: - Actions
    @IBAction func profilePhotoButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func screenshot1ButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func screenshot2ButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func screenshot3ButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func screenshot4ButtonPressed(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSetup()
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func viewSetup(){
        self.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    @IBAction func doneAction(sender: AnyObject) {
        // Save data here, then dismiss the view

        // +++ Data Saving needs to be implemented here +++
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelAction(sender: AnyObject) {
        // Dismiss the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
