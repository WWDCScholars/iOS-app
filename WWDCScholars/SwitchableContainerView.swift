//
//  SwitchableContainerView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol ScholarsSwitchableContainerView {
    var navigationBarItemImage: UIImage? { get }
}

internal final class ScholarsMapContainerView: UIView, ScholarsSwitchableContainerView {
    
    // MARK: - Internal Properties
    
    internal let navigationBarItemImage = UIImage(named: "mapNavigationBarIconFilled")
}

internal final class ScholarsListContainerView: UIView, ScholarsSwitchableContainerView {
    
    // MARK: - Internal Properties
    
    internal let navigationBarItemImage = UIImage(named: "listNavigationBarIconFilled")
}
