//
//  SizeableCollectionViewCellContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal protocol SizeableCollectionViewCellContent: AnyObject {
    func size(within collectionView: UICollectionView, sizingModifiers: CollectionViewSectionContentSizingModifiers) -> CGSize
}
