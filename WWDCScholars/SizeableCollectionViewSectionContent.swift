//
//  SizeableCollectionViewSectionContent.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol SizeableCollectionViewSectionContent {
    var sizingModifiers: CollectionViewSectionContentSizingModifiers { get }
}
