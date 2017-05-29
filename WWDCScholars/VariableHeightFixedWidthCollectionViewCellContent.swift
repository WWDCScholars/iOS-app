//
//  VariableHeightFixedWidthCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal protocol VariableHeightFixedWidthCollectionViewCellContent: class, SizeableCollectionViewCellContent, VariableHeightCollectionViewCellContent {
    var width: CGFloat { get }
}

internal extension VariableHeightFixedWidthCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width
        let height = self.height(within: collectionView, minimumLineSpacing: sizingModifiers.minimumLineSpacing, edgeInsets: sizingModifiers.edgeInsets)
        return CGSize(width: width, height: height)
    }
}
