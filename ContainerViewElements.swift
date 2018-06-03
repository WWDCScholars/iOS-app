//
//  ContainerViewElements.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 26/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class ContainerViewElements {
    
    // MARK: - Internal Properties
    
    internal let view: UIView?
    internal let viewController: ContainerViewController?
    
    // MARK: - Lifecycle
    
    internal init(view: UIView?, viewController: ContainerViewController?) {
        self.view = view
        self.viewController = viewController
    }
}
