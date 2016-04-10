//
//  EditDetailsViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 10.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class EditDetailsViewController: UIViewController {

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
