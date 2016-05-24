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
    @IBOutlet private weak var iOSImageView: UIImageView!
    @IBOutlet private weak var webImageView: UIImageView!
    @IBOutlet private weak var projectManagementImageView: UIImageView!
    @IBOutlet private weak var databaseImageView: UIImageView!
    @IBOutlet private weak var designImageView: UIImageView!
    @IBOutlet private weak var appleWatchImageView: UIImageView!
    
    func setIconVisibility(tasks: [String]) {
        //This code is temporary until I think of a better implementation
        
        self.iOSImageView.hidden = !tasks.contains("iOS")
        self.webImageView.hidden = !tasks.contains("Web")
        self.projectManagementImageView.hidden = !tasks.contains("Project Management")
        self.databaseImageView.hidden = !tasks.contains("Database")
        self.designImageView.hidden = !tasks.contains("Design")
        self.appleWatchImageView.hidden = !tasks.contains("Apple Watch")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scholarImageView.clipsToBounds = true
        self.scholarImageView.layer.cornerRadius = 7
    }
}
