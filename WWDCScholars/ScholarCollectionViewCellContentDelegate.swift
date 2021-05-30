//
//  ScholarCollectionViewCellContentDelegate.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 27/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol ScholarCollectionViewCellContentDelegate: AnyObject {
    func presentProfile(for scholar: Scholar)
}
