//
//  VariableWidthFixedHeightCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

protocol VariableWidthFixedHeightCollectionViewCellContent: SizeableCollectionViewCellContent, VariableWidthCollectionViewCellContent {
    var height: CGFloat { get }
}

extension VariableWidthFixedHeightCollectionViewCellContent {
    
    // MARK: - Functions
    
    func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width(within: collectionView, minimumInteritemSpacing: sizingModifiers.minimumInteritemSpacing, edgeInsets: sizingModifiers.edgeInsets)
        let height = self.height
        return CGSize(width: width, height: height)
    }
}
