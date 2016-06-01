//
//  Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 09.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

extension UIColor {
    class func scholarsPurpleColor() -> UIColor {
        return UIColor(red: 65.0 / 255.0, green: 58.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }
    
    class func transparentScholarsPurpleColor() -> UIColor {
        return UIColor(red: 65.0 / 255.0, green: 58.0 / 255.0, blue: 153.0 / 255.0, alpha: 0.75)
    }
    
    class func transparentWhiteColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.75)
    }
    
    class func transparentBlackColor() -> UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.75)
    }
    
    class func mediumBlackTextColor() -> UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.50)
    }
    
    class func mediumWhiteTextColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.50)
    }
    
    class func goldColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 192.0 / 255.0, blue: 103.0 / 255.0, alpha: 1.0)
    }
    
    class func standardGreyColor() -> UIColor {
        return UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }

    //for alternative testing of design changes - WWDC16 Colors
    class func wwdc16DarkBackground() -> UIColor {
        return UIColor(red:0.13, green:0.13, blue:0.17, alpha:1.0)
    }
    
    class func wwdc16LighterBackground() -> UIColor {
        return UIColor(red:0.21, green:0.22, blue:0.25, alpha:1.0)
    }
    
    class func wwdc16Orange() -> UIColor {
        return UIColor(red:0.82, green:0.56, blue:0.36, alpha:1.0)
    }
    
    class func wwdc16Red() -> UIColor {
        return UIColor(red:0.86, green:0.24, blue:0.24, alpha:1.0)
    }
    
    class func wwdc16Fusia() -> UIColor {
        return UIColor(red:0.72, green:0.22, blue:0.60, alpha:1.0)
    }
    
    class func wwdc16Purple() -> UIColor {
        return UIColor(red:0.52, green:0.52, blue:0.81, alpha:1.0)
    }
    
    class func wwdc16ForestGreen() -> UIColor {
        return UIColor(red:0.52, green:0.52, blue:0.81, alpha:1.0)
    }
    
    class func wwdc16MintGreen() -> UIColor {
        return UIColor(red:0.58, green:0.78, blue:0.44, alpha:1.0)
    }
    
    class func wwdc16Green() -> UIColor {
        return UIColor(red:0.32, green:0.74, blue:0.35, alpha:1.0)
    }
    
    class func wwdc16BlueGreen() -> UIColor {
        return UIColor(red:0.00, green:0.67, blue:0.65, alpha:1.0)
    }
    
    class func wwdc16Blue() -> UIColor {
        return UIColor(red:0.27, green:0.44, blue:0.85, alpha:1.0)
    }
    
    //Just like Apple News Style
    class func transparentScholarsWhiteColor() -> UIColor {
        return UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.7)
    }
    
}

//Segmented Control - Mainly use in the Scholar's Section that has submitted two apps (offline and online)
extension UISegmentedControl {
    func applyScholarsSegmentedStyle() {
        
        //Styling using Scholars Purple
        self.tintColor = UIColor.scholarsPurpleColor()

        //Styling using WWDC16
//        self.tintColor = UIColor.wwdc16Purple()
    }
}

extension UIButton {
    func applyScholarsButtonStyle() {
        self.layer.cornerRadius = 7.0
        self.layer.borderColor = UIColor.scholarsPurpleColor().CGColor
        self.layer.borderWidth = 0.5
        self.setTitleColor(UIColor.scholarsPurpleColor(), forState: .Normal)
    }
    
    func applyActiveChatButtonStyle() {
        self.layer.cornerRadius = 4.0
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.backgroundColor = UIColor.scholarsPurpleColor()
        self.enabled = true
    }
    
    func applyInactiveChatButtonStyle() {
        self.layer.cornerRadius = 4.0
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.backgroundColor = UIColor.lightGrayColor()
        self.enabled = false
    }
}

//Scholar's Name Label
extension UILabel {
    func applyPurpleBackgroundStyle() {
        
        //Styling using Scholars Purple
        self.backgroundColor = UIColor.transparentScholarsPurpleColor()
        self.textColor = UIColor.whiteColor()
        self.font = UIFont.systemFontOfSize(15)

        //Styling using Apple News White
//        self.backgroundColor = UIColor.transparentWhiteColor()
//        self.font = UIFont (name: "HelveticaNeue-Light", size: 15)
//        self.textColor = UIColor.grayColor()
    }
}

extension UIView {
    func applyExtendedNavigationBarContainerStyle() {
        //Styling using Scholars Purple
        self.backgroundColor = UIColor.scholarsPurpleColor()
        
        //Styling Using New WWDC16 Color
//        self.backgroundColor = UIColor.wwdc16LighterBackground()
    }
    
    func applyRoundedCorners() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    func applyExtendedNavigationBarStyle() {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        
        //Styling using Scholars Purple Color
        let colouredImage = UIImage.imageWithSize(CGSize(width: 1, height: 1), color: UIColor.scholarsPurpleColor())
        
        //Styling Using New WWDC16 Color
//        let colouredImage = UIImage.imageWithSize(CGSize(width: 1, height: 1), color: UIColor.wwdc16LighterBackground())
        
        self.navigationController?.navigationBar.setBackgroundImage(colouredImage, forBarMetrics: UIBarMetrics.Default)
    }
}

extension UINavigationBar {
    func applyExtendedNavigationBarStyle() {
        self.translucent = false
        self.shadowImage = UIImage(named: "transparentPixel")
       
        //Styling using Scholars Purple
        let colouredImage = UIImage.imageWithSize(CGSize(width: 1, height: 1), color: UIColor.scholarsPurpleColor())
        
        //Styling Using New WWDC16 Color
//        let colouredImage = UIImage.imageWithSize(CGSize(width: 1, height: 1), color: UIColor.wwdc16LighterBackground())
        
        self.setBackgroundImage(colouredImage, forBarMetrics: UIBarMetrics.Default)
    }
    
    static func applyNavigationBarStyle() {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false

        //Styling using Scholars Purple
        UINavigationBar.appearance().backgroundColor = UIColor.scholarsPurpleColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Styling using WWDC16
//        UINavigationBar.appearance().backgroundColor = UIColor.wwdc16LighterBackground()
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont (name: "HelveticaNeue-Medium", size: 17)!,
//        NSForegroundColorAttributeName: UIColor.wwdc16BlueGreen()]
    
    }
}