//
//  UIColor+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal extension UIColor {
    
    // MARK: - Internal Functions
    
    static var scholarsPurple: UIColor {
        UIColor(named: "scholarsPurple")!
    }
    
    static var scholarsTranslucentPurple: UIColor {
        return UIColor(red: 10.0 / 255.0, green: 1.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    }
    
    static var navigationBarBorderGray: UIColor {
        if #available(iOS 13.0, *) {
            return .quaternarySystemFill
        }

        return UIColor(red: 178.0 / 255.0, green: 178.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }

    static var tabBarTint: UIColor {
        UIColor(named: "tabBarTint")!
    }
    
    static var backgroundGray: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        }
        
        return UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    static var backgroundElementGray: UIColor {
        return UIColor(red: 130.0 / 255.0, green: 130.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    }
    
    static var titleTextDark: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        }

        return UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    
    static var contentTextDark: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        }

        return UIColor(red: 146.0 / 255.0, green: 146.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
    }
    
    static var titleTextLight: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    static var contentTextLight: UIColor {
        return UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    }
    
    static var selectedTransparentWhite: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.2)
    }
    
    static var thumbnailTransparentPurple: UIColor {
        return self.scholarsPurple.withAlphaComponent(.threeQuarters)
    }
}
