//
//  UIControl+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal extension UIControl {
    
    // MARK: - Internal Functions
    
    internal func replaceTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        self.removeTarget(nil, action: nil, for: .allEvents)
        self.addTarget(target, action: action, for: controlEvents)
    }
}
