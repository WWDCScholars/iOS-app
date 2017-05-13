//
//  Selectable.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal protocol Selectable: class {
    var isSelected: Bool { get set }

    func performAction(on contentContainer: Reloadable?, with sectionContent: [SectionContent], at indexPath: IndexPath)
}
