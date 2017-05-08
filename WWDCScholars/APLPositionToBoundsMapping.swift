//
//  APLPositionToBoundsMapping.swift
//  UIKit Dynamics
//
//  Created by Sam Eckert on 08.05.17.
//  Copyright © 2017 Sam0711er. All rights reserved.
//
//
import UIKit

@objc protocol ResizableDynamicItem : UIDynamicItem{
    var bounds: CGRect {get set}
}

//extension UIDynamicItem where Self : ResizableDynamicItem {}
extension UIView: ResizableDynamicItem {}

class APLPositionToBoundsMapping: NSObject, UIDynamicItem {
    
    var target: ResizableDynamicItem
    
    init(target: ResizableDynamicItem) {
        self.target = target
        super.init()
    }
    

    
    //| ----------------------------------------------------------------------------
    
    // MARK: -
    // MARK: UIDynamicItem
    
    //| ----------------------------------------------------------------------------
    //  Manual implementation of the getter for the bounds property required by
    //  UIDynamicItem.
    //
    
    var bounds: CGRect {
        // Pass through
        let targetB = self.target.bounds
        return CGRect(x: targetB.origin.x, y: targetB.origin.y, width: targetB.size.width * 0.8, height: targetB.size.height * 0.8)
    }
    
    //| ----------------------------------------------------------------------------
    //  Manual implementation of the getter and setter for the center property required by
    //  UIDynamicItem.
    //
    
    var center: CGPoint {
        get {
            // center.x <- bounds.size.width, center.y <- bounds.size.height
            return CGPoint(x: self.target.bounds.size.width, y: self.target.bounds.size.height);
        }set {
            self.target.bounds = CGRect(x: 0, y: 0, width: newValue.x, height: newValue.y);
        }
    }
    
    //| ----------------------------------------------------------------------------
    //  Manual implementation of the getter and setter for the transform property required by
    //  UIDynamicItem.
    //
    
    var transform: CGAffineTransform{
        // Pass through
        get {
            return self.target.transform
        }
        set {
            self.target.transform =   (target.transform).concatenating(newValue)
        }
    }
}
