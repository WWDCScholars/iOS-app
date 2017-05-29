//
//  VariableWidthFixedHeightCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal protocol VariableWidthFixedHeightCollectionViewCellContent: class, SizeableCollectionViewCellContent, VariableWidthCollectionViewCellContent {
    var height: CGFloat { get }
}

internal extension VariableWidthFixedHeightCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width(within: collectionView, minimumInteritemSpacing: sizingModifiers.minimumInteritemSpacing, edgeInsets: sizingModifiers.edgeInsets)
        let height = self.height
        return CGSize(width: width, height: height)
    }
}
