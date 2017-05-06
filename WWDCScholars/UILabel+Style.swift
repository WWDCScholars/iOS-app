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
        self.textColor = .darkTextGray
    }
    
    internal func applyProfileTitleStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .lightTextGray
    }
    
    internal func applyProfileContentStyle() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = .lightTextGray
    }
}
