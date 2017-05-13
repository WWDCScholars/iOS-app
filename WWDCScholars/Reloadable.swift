//
//  Reloadable.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol Reloadable: class {
    func reload(sections: IndexSet)
}

extension UICollectionView: Reloadable {

    // MARK: - internal Functions

    internal func reload(sections: IndexSet) {
        self.reloadSections(sections)
    }
}

extension UITableView: Reloadable {

    // MARK: - internal Functions

    internal func reload(sections: IndexSet) {
        self.reloadSections(sections, with: .automatic)
    }
}
