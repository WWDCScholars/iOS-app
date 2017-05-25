//
//  UITabBarController+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 25/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal extension UITabBarController {
    
    // MARK: - Internal Functions
    
    internal func index<T: UIViewController>(of viewController: T.Type) -> Int? {
        return self.viewControllers?.index(where: { type(of: $0) == viewController })
    }
}
