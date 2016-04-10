//
//  CreditTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 09/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class CreditTableViewCell: UITableViewCell {
    @IBOutlet weak var scholarImageView: UIImageView!
    @IBOutlet weak var scholarNameLabel: UILabel!
    @IBOutlet weak var iOSImageView: UIImageView!
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var projectManagementImageView: UIImageView!
    @IBOutlet weak var databaseImageView: UIImageView!
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var appleWatchImageView: UIImageView!
    
    func setIconVisibility(tasks: [String]) {
        if !tasks.contains("iOS") {
            iOSImageView.hidden = true
        }
        
        if !tasks.contains("Web") {
            webImageView.hidden = true
        }
        
        if !tasks.contains("Project Management") {
            projectManagementImageView.hidden = true
        }
        
        if !tasks.contains("Database") {
            databaseImageView.hidden = true
        }
        
        if !tasks.contains("Design") {
            designImageView.hidden = true
        }
        
        if !tasks.contains("Apple Watch") {
            appleWatchImageView.hidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
