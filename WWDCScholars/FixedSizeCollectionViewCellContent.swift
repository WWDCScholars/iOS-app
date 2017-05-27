//
//  FixedSizeCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol FixedSizeCollectionViewCellContent: class, SizeableCollectionViewCellContent {
    var width: CGFloat { get }
    var height: CGFloat { get }
}

internal extension FixedSizeCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width
        let height = self.height
        return CGSize(width: width, height: height)
    }
}
