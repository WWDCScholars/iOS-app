//
//  UILabel+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 06/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal extension UILabel {

    // MARK: - Internal Functions
    
    internal func applyProfileNameStyle() {
        self.font = UIFont.systemFont(ofSize: 25.0)
        self.textColor = .titleTextDark
    }
    
    internal func applyProfileTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextDark
    }
    
    internal func applyProfileContentStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .contentTextDark
    }
    
    internal func applyBlogPostInfoTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextLight
    }
    
    internal func applyBlogPostInfoAuthorStyle() {
        self.font = UIFont.systemFont(ofSize: 10.0)
        self.textColor = .contentTextLight
    }
    
    internal func addTextSpacing(spacing: Float) {
        if text != nil {
            let attributedString = NSMutableAttributedString(string: text!)
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
