//
//  UILabel+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 06/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    // MARK: - Functions
    
    func applyDetailHeaderTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 25.0)
        self.textColor = .titleTextDark
    }
    
    func applyDetailTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextDark
    }
    
    func applyDetailContentStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .contentTextDark
    }
    
    func applyBlogPostInfoTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextLight
    }
    
    func applyBlogPostInfoAuthorStyle() {
        self.font = UIFont.systemFont(ofSize: 10.0)
        self.textColor = .contentTextLight
    }
    
    func addTextSpacing(spacing: Float) {
        if text != nil {
            let attributedString = NSMutableAttributedString(string: text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }

    func applyScholarsWWDCYearInfoTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 14.0)
        self.textColor = .titleTextLight
    }
    
    func applyScholarsTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .titleTextLight
    }
    
    func applyBackgroundTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .backgroundElementGray
    }
    
    func applyScholarClusterStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textAlignment = .center
        self.textColor = .white
    }
}
