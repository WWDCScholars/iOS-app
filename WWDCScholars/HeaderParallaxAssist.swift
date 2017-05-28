//
//  HeaderParallaxAssist.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 25/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal protocol HeaderParallaxAssist: class {}

internal extension HeaderParallaxAssist {
    
    // MARK: - Internal Functions
    
    internal func updateHeaderParallax(for scrollView: UIScrollView, on view: UIView?, baseHeight: CGFloat) {
        var frame = CGRect(x: 0.0, y: 0.0, width: scrollView.bounds.width, height: baseHeight)
        
        if scrollView.contentOffset.y < baseHeight {
            frame.origin.y = scrollView.contentOffset.y
            frame.size.height = -scrollView.contentOffset.y + baseHeight
        }
        
        view?.frame = frame
    }
}
