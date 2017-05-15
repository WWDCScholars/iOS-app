//
//  VariableDimensionCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol VariableDimensionCollectionViewCellContent {
    var axisCellCount: Int { get }
}

internal extension VariableDimensionCollectionViewCellContent {
    
    // MARK: - Internal Functions
    
    internal func dimension(within collectionView: UICollectionView, spacing: CGFloat, edgeInset1: CGFloat, edgeInset2: CGFloat) -> CGFloat {
        let axisCellCount = CGFloat(self.axisCellCount)
        let dimension = collectionView.frame.width / axisCellCount
        let edgeInset1 = edgeInset1 / axisCellCount
        let edgeInset2 = edgeInset2 / axisCellCount
        let dimensionMinusEdgeInsets = dimension - edgeInset1 - edgeInset2
        let spacing = ((spacing * (axisCellCount - 1)) / axisCellCount)
        let dimensionMinusEdgeInsetsSpacing = floor(dimensionMinusEdgeInsets - spacing)
        return dimensionMinusEdgeInsetsSpacing
    }
}
