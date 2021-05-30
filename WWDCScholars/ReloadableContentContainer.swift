//
//  ReloadableContentContainer.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal protocol ReloadableContentContainer: AnyObject {
    func reload(sections: IndexSet)
}

extension UICollectionView: ReloadableContentContainer {

    // MARK: - internal Functions

    internal func reload(sections: IndexSet) {
        self.reloadSections(sections)
    }
}

extension UITableView: ReloadableContentContainer {

    // MARK: - internal Functions

    internal func reload(sections: IndexSet) {
        self.reloadSections(sections, with: .automatic)
    }
}
