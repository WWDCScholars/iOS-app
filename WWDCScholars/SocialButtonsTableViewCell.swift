//
//  SocialButtonsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

protocol SocialButtonDelegate {
    func openURL(url: String)
    func composeEmail(address: String)
}

class SocialButtonsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var iconsView: UIView!
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
        
        self.linkedInImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.linkedInTapped), forControlEvents: .TouchUpInside)
        self.facebookImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.facebookTapped), forControlEvents: .TouchUpInside)
        self.twitterImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.twitterTapped), forControlEvents: .TouchUpInside)
        self.githubImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.gitHubTapped), forControlEvents: .TouchUpInside)
        self.websiteImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.websiteTapped), forControlEvents: .TouchUpInside)
        self.emailImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.emailTapped), forControlEvents: .TouchUpInside)
        self.appStoreImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.appStoreTapped), forControlEvents: .TouchUpInside)
        self.iMessageImageView.addTarget(self, action: #selector(SocialButtonsTableViewCell.iMessageTapped), forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Internal functions
    
    internal func isStringNumerical(string : String) -> Bool {
        // Only allow numbers. Look for anything not a number.
        let range = string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return (range == nil)
    }
    
    internal func linkedInTapped() {
        
        var explicitLinkedInURL = URL!()
        explicitLinkedInURL = self.scholar.linkedInURL

        print(explicitLinkedInURL)
        
        self.delegate?.openURL(self.scholar.linkedInURL!)
        
    }
    
    internal func gitHubTapped() {
        self.delegate?.openURL(self.scholar.githubURL!)
    }
    
    internal func facebookTapped() {
        
        let facebookProfileID = self.scholar.facebookURL!.componentsSeparatedByString("/").last
        if facebookProfileID != nil {
            
            let deeplink = NSURL(string: "fb://profile/\(facebookProfileID!)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            
            if UIApplication.sharedApplication().canOpenURL(deeplink!) {
                UIApplication.sharedApplication().openURL(deeplink!)
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
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: self.scholar.iTunesURL!)!) {
            UIApplication.sharedApplication().openURL(NSURL(string: self.scholar.iTunesURL!)!)
        }
        
    }
    
    internal func twitterTapped() {
        
        let twitterProfileID : String!
        twitterProfileID = self.scholar.twitterURL!.componentsSeparatedByString("/").last
        
        if twitterProfileID != nil {
            let tweetbotURL = NSURL(string: "tweetbot://\(twitterProfileID!)/user_profile/\(twitterProfileID)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)

            let deeplink = NSURL(string: "twitter://user?screen_name=\(twitterProfileID!)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            
            if UIApplication.sharedApplication().canOpenURL(tweetbotURL!){
                UIApplication.sharedApplication().openURL(tweetbotURL!)
            }
            else if UIApplication.sharedApplication().canOpenURL(deeplink!) {
                UIApplication.sharedApplication().openURL(deeplink!)
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
                let iMessageURL = NSURL(string: "sms:+\(scholariMsgEmail)")!

                if UIApplication.sharedApplication().canOpenURL(iMessageURL){
                    UIApplication.sharedApplication().openURL(iMessageURL)
                    print("iMessage phone number does  work, it equals \(scholariMsgEmail)")
                    
                }else{
                    print("iMessage phone number does not work, it equals \(scholariMsgEmail)")
                }
            }else{
                let iMessageURL = NSURL(string: "sms:\(scholariMsgEmail)")!
                
                if UIApplication.sharedApplication().canOpenURL(iMessageURL){
                    UIApplication.sharedApplication().openURL(iMessageURL)
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
        self.linkedInImageView.hidden = self.scholar.linkedInURL == nil
        self.facebookImageView.hidden = self.scholar.facebookURL == nil
        self.githubImageView.hidden = self.scholar.githubURL == nil
        self.websiteImageView.hidden = self.scholar.websiteURL == nil
        self.appStoreImageView.hidden = self.scholar.iTunesURL == nil
        self.twitterImageView.hidden = self.scholar.twitterURL == nil
        self.iMessageImageView.hidden = self.scholar.iMessage == nil
        
        self.emailImageView.hidden = false //Never hidden
    }
    
    
}


