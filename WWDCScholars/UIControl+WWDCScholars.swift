//
//  UIControl+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

extension UIControl {
    
    // MARK: - Functions
    
    func replaceTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.removeTarget(nil, action: nil, for: .allEvents)
        self.addTarget(target, action: action, for: controlEvents)
    }
}
