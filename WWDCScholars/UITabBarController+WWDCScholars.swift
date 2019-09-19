//
//  UITabBarController+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 25/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    
    // MARK: - Functions
    
    func index<T: UIViewController>(of viewController: T.Type) -> Int? {
        return self.viewControllers?.firstIndex(where: { $0 is T })
    }
    
    func indexOfNavigationController<T: UIViewController>(containing viewController: T.Type) -> Int? {
        return self.viewControllers?.firstIndex(where: { ($0 as? UINavigationController)?.viewControllers.first is T })
    }
}
