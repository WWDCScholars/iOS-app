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
    @IBOutlet fileprivate weak var iOSImageView: UIImageView!
    @IBOutlet fileprivate weak var webImageView: UIImageView!
    @IBOutlet fileprivate weak var projectManagementImageView: UIImageView!
    @IBOutlet fileprivate weak var databaseImageView: UIImageView!
    @IBOutlet fileprivate weak var designImageView: UIImageView!
    @IBOutlet fileprivate weak var appleWatchImageView: UIImageView!
    @IBOutlet fileprivate weak var marketingImageView: UIImageView!
    @IBOutlet weak var apiImageView: UIImageView!
    @IBOutlet weak var serverImageView: UIImageView!
    @IBOutlet weak var deploymentImageView: UIImageView!
    
    
    func setIconVisibility(_ tasks: [String]) {
        //This code is temporary until I think of a better implementation
        
        self.iOSImageView.isHidden = !tasks.contains("iOS")
        self.webImageView.isHidden = !tasks.contains("Web")
        self.projectManagementImageView.isHidden = !tasks.contains("Project Management")
        self.databaseImageView.isHidden = !tasks.contains("Database")
        self.designImageView.isHidden = !tasks.contains("Design")
        self.appleWatchImageView.isHidden = !tasks.contains("Apple Watch")
        self.marketingImageView.isHidden = !tasks.contains("Marketing")
        self.apiImageView.isHidden = !tasks.contains("API")
        self.serverImageView.isHidden = !tasks.contains("Server")
        self.deploymentImageView.isHidden = !tasks.contains("Deployment")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scholarImageView.clipsToBounds = true
        self.scholarImageView.layer.cornerRadius = 7
    }
}
