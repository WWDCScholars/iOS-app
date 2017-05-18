//
//  ProfileSocialAccountsFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 06/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ProfileSocialAccountsFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func accountButtons() -> [UIButton] {
        let buttons = [self.facebookButton(), self.twitterButton()]
        return buttons
    }
    
    // MARK: - Private Functions
    
    private static func facebookButton() -> UIButton {
        return self.accountButton(withImage: "facebook")
    }
    
    private static func twitterButton() -> UIButton {
        return self.accountButton(withImage: "twitter")
    }
    
    private static func accountButton(withImage named: String) -> UIButton {
        let button = UIButton()
        let image = UIImage(named: named)
        button.setBackgroundImage(image, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        return button
    }
}
