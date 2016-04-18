//
//  CreditsManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 18/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class CreditsManager {
    static let sharedInstance = CreditsManager()
    
    var credits: [Credit] = []
    
    // MARK: - Public functions
    
    func getCredits() {
        if let path = NSBundle.mainBundle().pathForResource("Credits", ofType: "plist"), array = NSArray(contentsOfFile: path) {
            self.credits.removeAll()
            
            self.creditsFromArray(array)
        }
    }
    
    func getScholar(indexPath: NSIndexPath) -> Scholar? {
        if let scholarID = self.credits[indexPath.item].id {
            let scholar = DatabaseManager.sharedInstance.scholarForId(scholarID)
            
            return scholar
        }
        
        return nil
    }
    
    func checkForCredit(scholar: Scholar) -> Bool {        
        for credit in self.credits {
            if scholar.id == credit.id {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Private functions
    
    private func creditsFromArray(items: NSArray) {
        for item in items as! [NSDictionary] {
            let scholarName = item["Name"] as! String
            let scholarLocation = item["Location"] as! String
            let scholarTasks = item["Tasks"] as! [String]
            let scholarID = item["ID"] as! String
            
            self.credits.append(Credit.getCredit(scholarName, location: scholarLocation, tasks: scholarTasks, image: scholarName, id: scholarID))
        }
    }
}
