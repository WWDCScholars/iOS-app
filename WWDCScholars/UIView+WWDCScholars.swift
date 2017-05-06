//
//  UIView+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 06/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal extension UIView {
    
    // MARK: - Internal Functions
    
    internal func isSquare() -> Bool {
        return self.frame.width == self.frame.height
    }
    
    internal func round() {
        if self.isSquare() {
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
    }
}
