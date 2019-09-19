//
//  ContainerViewElements.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 26/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

final class ContainerViewElements {
    
    // MARK: - Properties
    
    let view: UIView?
    let viewController: ContainerViewController?
    
    // MARK: - Lifecycle
    
    init(view: UIView?, viewController: ContainerViewController?) {
        self.view = view
        self.viewController = viewController
    }
}
