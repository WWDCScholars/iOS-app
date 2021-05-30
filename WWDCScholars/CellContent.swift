//
//  CellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol CellContent: AnyObject {
    var reuseIdentifier: String { get }
    var id: String? { get }
}
