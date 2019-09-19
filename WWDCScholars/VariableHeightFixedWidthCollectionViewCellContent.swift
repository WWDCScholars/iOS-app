//
//  VariableHeightFixedWidthCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

protocol VariableHeightFixedWidthCollectionViewCellContent: SizeableCollectionViewCellContent, VariableHeightCollectionViewCellContent {
    var width: CGFloat { get }
}

extension VariableHeightFixedWidthCollectionViewCellContent {
    
    // MARK: - Functions
    
    func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width
        let height = self.height(within: collectionView, minimumLineSpacing: sizingModifiers.minimumLineSpacing, edgeInsets: sizingModifiers.edgeInsets)
        return CGSize(width: width, height: height)
    }
}
