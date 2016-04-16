//
//  CreditsViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 07.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var accessButton: UIButton!
    
    private var credits: [Credit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleUI()
        self.getCredits()
    }
    
    // MARK: - Private Functions

    private func creditsFromArray(items: NSArray) {
        for item in items as! [NSDictionary] {
            let scholarName = item["Name"] as! String
            let scholarLocation = item["Location"] as! String
            let scholarTasks = item["Tasks"] as! [String]
            
            self.credits.append(Credit.getCredit(scholarName, location: scholarLocation, tasks: scholarTasks, image: scholarName))
        }
        
        self.tableView.reloadData()
    }
    
    private func getCredits() {
        if let path = NSBundle.mainBundle().pathForResource("Credits", ofType: "plist"), array = NSArray(contentsOfFile: path) {
            self.credits.removeAll()
            
            self.creditsFromArray(array)
        }
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Credits"
        self.submitButton.applyScholarsButtonStyle()
        self.accessButton.applyScholarsButtonStyle()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.credits.count > 0 ? self.credits.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let creditCell = self.tableView.dequeueReusableCellWithIdentifier("creditCell") as! CreditTableViewCell
        let currentCredit = self.credits[indexPath.item]
        let creditNameText = NSMutableAttributedString(string: currentCredit.name)
        let creditLocationText = NSMutableAttributedString(string: " (\(currentCredit.location))")
        
        creditNameText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: creditNameText.length))
        creditLocationText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSRange(location: 0, length: creditLocationText.length))
        creditNameText.appendAttributedString(creditLocationText)
        
        creditCell.scholarNameLabel.attributedText = creditNameText
        creditCell.scholarImageView.image = currentCredit.image
        
        creditCell.setIconVisibility(currentCredit.tasks)
        
        return creditCell
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 67
    }
}
