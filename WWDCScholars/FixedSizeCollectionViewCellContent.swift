//
//  FixedSizeCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

protocol FixedSizeCollectionViewCellContent: SizeableCollectionViewCellContent {
    var width: CGFloat { get }
    var height: CGFloat { get }
}

extension FixedSizeCollectionViewCellContent {
    
    // MARK: - Functions
    
    func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize {
        let width = self.width
        let height = self.height
        return CGSize(width: width, height: height)
    }
}
