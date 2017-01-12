//
//  SocialButtonsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

protocol SocialButtonDelegate {
    func openURL(_ url: String)
    func composeEmail(_ address: String)
}

class SocialButtonsTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var iconsView: UIView!
    @IBOutlet weak var twitterImageView: UIButton!
    @IBOutlet weak var linkedInImageView: UIButton!
    @IBOutlet weak var emailImageView: UIButton!
    @IBOutlet weak var facebookImageView: UIButton!
    @IBOutlet weak var githubImageView: UIButton!
    @IBOutlet weak var websiteImageView: UIButton!
    @IBOutlet weak var appStoreImageView: UIButton!
    @IBOutlet var iMessageImageView: UIButton!
    
    var delegate: SocialButtonDelegate?
    var scholar: Scholar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.linkedInImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.linkedInTapped), for: .touchUpInside)
        self.facebookImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.facebookTapped), for: .touchUpInside)
        self.twitterImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.twitterTapped), for: .touchUpInside)
        self.githubImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.gitHubTapped), for: .touchUpInside)
        self.websiteImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.websiteTapped), for: .touchUpInside)
        self.emailImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.emailTapped), for: .touchUpInside)
        self.appStoreImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.appStoreTapped), for: .touchUpInside)
        self.iMessageImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.iMessageTapped), for: .touchUpInside)
    }
    
    // MARK: - Internal functions
    
    internal func isStringNumerical(_ string : String) -> Bool {
        // Only allow numbers. Look for anything not a number.
        let range = string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        return (range == nil)
    }
    
    internal func linkedInTapped() {
        
        var explicitLinkedInURL = String()
        explicitLinkedInURL = self.scholar.linkedInURL!

        print(explicitLinkedInURL)
        
        self.delegate?.openURL(self.scholar.linkedInURL!)
        
    }
    
    internal func gitHubTapped() {
        self.delegate?.openURL(self.scholar.githubURL!)
    }
    
    internal func facebookTapped() {
        
        let facebookProfileID = self.scholar.facebookURL!.components(separatedBy: "/").last
        if facebookProfileID != nil {
            
            let deeplink = Foundation.URL(string: "fb://profile/\(facebookProfileID!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            
            if UIApplication.shared.canOpenURL(deeplink!) {
                UIApplication.shared.openURL(deeplink!)
            } else {
               self.delegate?.openURL(self.scholar.facebookURL!)
            }
            
        } else {
            self.delegate?.openURL(self.scholar.facebookURL!)
        }
        
    }
    
    internal func websiteTapped() {
        self.delegate?.openURL(self.scholar.websiteURL!)
    }
    
    internal func emailTapped() {
        self.delegate?.composeEmail(self.scholar.email)
    }
    
    internal func appStoreTapped() {
        
        if UIApplication.shared.canOpenURL(Foundation.URL(string: self.scholar.iTunesURL!)!) {
            UIApplication.shared.openURL(Foundation.URL(string: self.scholar.iTunesURL!)!)
        }
        
    }
    
    internal func twitterTapped() {
        
        let twitterProfileID : String!
        twitterProfileID = self.scholar.twitterURL!.components(separatedBy: "/").last
        
        if twitterProfileID != nil {
            let tweetbotURL = Foundation.URL(string: "tweetbot://\(twitterProfileID!)/user_profile/\(twitterProfileID)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

            let deeplink = Foundation.URL(string: "twitter://user?screen_name=\(twitterProfileID!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            
            if UIApplication.shared.canOpenURL(tweetbotURL!){
                UIApplication.shared.openURL(tweetbotURL!)
            }
            else if UIApplication.shared.canOpenURL(deeplink!) {
                UIApplication.shared.openURL(deeplink!)
            } else {
                self.delegate?.openURL(self.scholar.twitterURL!)
            }
            
        } else {
            self.delegate?.openURL(self.scholar.twitterURL!)
        }
        
    }
    
    internal func iMessageTapped() {
     
        if let scholariMsgEmail = self.scholar.iMessage{
            
            if isStringNumerical(scholariMsgEmail){
                let iMessageURL = Foundation.URL(string: "sms:+\(scholariMsgEmail)")!

                if UIApplication.shared.canOpenURL(iMessageURL){
                    UIApplication.shared.openURL(iMessageURL)
                    print("iMessage phone number does  work, it equals \(scholariMsgEmail)")
                    
                }else{
                    print("iMessage phone number does not work, it equals \(scholariMsgEmail)")
                }
            }else{
                let iMessageURL = Foundation.URL(string: "sms:\(scholariMsgEmail)")!
                
                if UIApplication.shared.canOpenURL(iMessageURL){
                    UIApplication.shared.openURL(iMessageURL)
                    print("iMessage URL does  work, it equals \(scholariMsgEmail)")
                    
                }else{
                    print("iMessage URL does not work, it equals \(scholariMsgEmail)")
                }
            }
            
         
            
          
        }else{
            print("iMessageURL is nil")
        }
        
        
        
        
      
        

        
        
    }
    
    // MARK: - Public functions
    
    func setIconVisibility() {
        self.linkedInImageView.isHidden = self.scholar.linkedInURL == nil
        self.facebookImageView.isHidden = self.scholar.facebookURL == nil
        self.githubImageView.isHidden = self.scholar.githubURL == nil
        self.websiteImageView.isHidden = self.scholar.websiteURL == nil
        self.appStoreImageView.isHidden = self.scholar.iTunesURL == nil
        self.twitterImageView.isHidden = self.scholar.twitterURL == nil
        self.iMessageImageView.isHidden = self.scholar.iMessage == nil
        
        self.emailImageView.isHidden = false //Never hidden
    }
    
    
}


