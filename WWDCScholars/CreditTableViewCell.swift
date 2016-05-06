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
        //This code is temporary until I think of a better implementation
        
        self.iOSImageView.hidden = !tasks.contains("iOS") ? true : false
        self.webImageView.hidden = !tasks.contains("Web") ? true : false
        self.projectManagementImageView.hidden = !tasks.contains("Project Management") ? true : false
        self.databaseImageView.hidden = !tasks.contains("Database") ? true : false
        self.designImageView.hidden = !tasks.contains("Design") ? true : false
        self.appleWatchImageView.hidden = !tasks.contains("Apple Watch") ? true : false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.scholarImageView.clipsToBounds = true
        self.scholarImageView.layer.cornerRadius = 7
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
