//
//  VariableSizeCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol VariableSizeCollectionViewCellContent: class, SizeableCollectionViewCellContent, VariableHeightCollectionViewCellContent, VariableWidthCollectionViewCellContent {}

internal extension VariableSizeCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width(within: collectionView, minimumInteritemSpacing: sizingModifiers.minimumInteritemSpacing, edgeInsets: sizingModifiers.edgeInsets)
        let height = self.height(within: collectionView, minimumLineSpacing: sizingModifiers.minimumLineSpacing, edgeInsets: sizingModifiers.edgeInsets)
        return CGSize(width: width, height: height)
    }
}
