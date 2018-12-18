//
//  UILabel+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 06/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal extension UILabel {
    
    // MARK: - Internal Functions
    
    internal func applyDetailHeaderTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 25.0)
        self.textColor = .titleTextDark
    }
    
    internal func applyDetailTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextDark
    }
    
    internal func applyDetailContentStyle() {
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
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }

    internal func applyScholarsBatchTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 14.0)
        self.textColor = .titleTextLight
    }
    
    internal func applyScholarsTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextLight
    }
    
    internal func applyBackgroundTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .backgroundElementGray
    }
    
    internal func applyScholarClusterStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textAlignment = .center
        self.textColor = .white
    }
}
