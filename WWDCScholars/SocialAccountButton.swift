//
//  SocialAccountButton.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 28/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class SocialAccountButton: UIButton {
    
    // MARK: - Internal Properties
    
    internal var accountDetail: String?
    
    // MARK: - Lifecycle
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
