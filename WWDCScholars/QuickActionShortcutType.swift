//
//  QuickActionShortcutType.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 18/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal enum QuickActionShortcutType: String {
    case OpenMyProfile
    case OpenSavedScholars
    case OpenBlog
    case OpenActivity
    
    internal init?(identifier: String) {
        guard let shortIdentifier = identifier.components(separatedBy: ".").last else {
            return nil
        }
        
        self.init(rawValue: shortIdentifier)
    }
}
