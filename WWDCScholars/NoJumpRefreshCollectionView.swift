//
//  NoJumpRefreshCollectionView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class NoJumpRefreshCollectionView: UICollectionView {
    override var contentInset: UIEdgeInsets {
        willSet {
            if self.tracking {
                let diff = newValue.top - self.contentInset.top
                var translation = self.panGestureRecognizer.translationInView(self)
                translation.y -= diff * 3.0 / 2.0
                self.panGestureRecognizer.setTranslation(translation, inView: self)
            }
        }
    }
}