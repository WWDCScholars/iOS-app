//
//  ExampleScholar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol ExampleScholar {
    var firstName: String { get }
    var lastName: String { get }
    var profileImage: UIImage { get }
}

internal final class ScholarOne: ExampleScholar {
    
    // MARK: - Internal Properties
    
    internal let firstName = "Andrew"
    internal let lastName = "Walker"
    internal let profileImage = UIImage(named: "profile")!
}
