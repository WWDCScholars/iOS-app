//
//  VariableHeightCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol VariableHeightCollectionViewCellContent: VariableDimensionCollectionViewCellContent {}

internal extension VariableHeightCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func height(within collectionView: UICollectionView, minimumLineSpacing: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat {
        return self.dimension(within: collectionView, spacing: minimumLineSpacing, edgeInset1: edgeInsets.top, edgeInset2: edgeInsets.bottom)
    }
}
