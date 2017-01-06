//
//  NoJumpRefreshTableView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class NoJumpRefreshTableView: UITableView {
    override var contentInset: UIEdgeInsets {
        willSet {
            if self.isTracking {
                let diff = newValue.top - self.contentInset.top
                var translation = self.panGestureRecognizer.translation(in: self)
                translation.y -= diff * 3.0 / 2.0
                self.panGestureRecognizer.setTranslation(translation, in: self)
            }
        }
    }
}
