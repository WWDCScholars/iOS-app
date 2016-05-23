//
//  InterfaceController.swift
//  WWDCScholars watchOS App Extension
//
//  Created by Sam Eckert on 23.05.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var scholarAmount: WKInterfaceLabel!
    @IBOutlet var mostCommonCity: WKInterfaceLabel!
    @IBOutlet var maleFemaleRatio: WKInterfaceLabel!
    @IBOutlet var averageAge: WKInterfaceLabel!
    
    @IBOutlet var youngestScholarAge: WKInterfaceLabel!
    @IBOutlet var oldestScholarAge: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        
        
        let mfRatioText = NSMutableAttributedString()
     //   mfRatioText.appendAttributedString(NSAttributedString(string: String.fontAwesomeIconWithName(FontAwesome.Male), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!))
        mfRatioText.appendAttributedString(NSAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)] as Dictionary!))
        
        mfRatioText.appendAttributedString(NSAttributedString(string: " / ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)] as Dictionary!))

      //  mfRatioText.appendAttributedString(NSAttributedString(string: String.fontAwesomeIconWithName(FontAwesome.Female), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!))
        mfRatioText.appendAttributedString(NSAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)] as Dictionary!))
        
        maleFemaleRatio.setAttributedText(mfRatioText)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        reload()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func goToScholars() {
        self.pushControllerWithName("scholars", context: nil)
    }
    
    @IBAction func reload() {
        
        /*
        WKInterfaceController.openParentApplication(["pfquery_request": "dummy_val"]) { userInfo, error in
            print("User Info: \(userInfo)")
            print("Error: \(error)")
            
            let data = (userInfo as NSDictionary)
            
            if let success = data["success"] as? NSNumber {
                if success.boolValue == true {
                    let male = data.objectForKey("male") as! NSNumber
                    let female = data.objectForKey("female") as! NSNumber
                    let total = data.objectForKey("totalWinners") as! NSNumber
                    let averageAge = data.objectForKey("averageAge") as! NSNumber
                    
                    let youngestAge = data.objectForKey("youngest") as! NSNumber
                    let oldestAge = data.objectForKey("oldest") as! NSNumber
                    
                    let mfRatioText = NSMutableAttributedString()
      //              mfRatioText.appendAttributedString(NSAttributedString(string: String.fontAwesomeIconWithName(FontAwesome.Male), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!))
                    mfRatioText.appendAttributedString(NSAttributedString(string: ": \(male)     ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)] as Dictionary!))
                    
     //               mfRatioText.appendAttributedString(NSAttributedString(string: String.fontAwesomeIconWithName(FontAwesome.Female), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!))
                    mfRatioText.appendAttributedString(NSAttributedString(string: ": \(female)", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)] as Dictionary!))
                    
                    self.maleFemaleRatio.setAttributedText(mfRatioText)
                    
                    self.scholarAmount.setText("\(total) out of 350")
                    self.averageAge.setText(averageAge.description)
                    
                    self.youngestScholarAge.setText("\(youngestAge)")
                    self.oldestScholarAge.setText("\(oldestAge)")
                    
                }
            }
        }*/
    }
}
