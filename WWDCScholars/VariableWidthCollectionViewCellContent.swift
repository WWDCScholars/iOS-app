//
//  VariableWidthCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal protocol VariableWidthCollectionViewCellContent: VariableDimensionCollectionViewCellContent {}

internal extension VariableWidthCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func width(within collectionView: UICollectionView, minimumInteritemSpacing: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat {
        return self.dimension(within: collectionView, spacing: minimumInteritemSpacing, edgeInset1: edgeInsets.left, edgeInset2: edgeInsets.right)
    }
}
