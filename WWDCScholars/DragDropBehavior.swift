//
//  DragDropBehavior.swift
//  DesignerNewsApp
//
//  Created by James Tang on 22/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

@objc public protocol DragDropBehaviorDelegate : class {
    func dragDropBehavior(_ behavior: DragDropBehavior, viewDidDrop view:UIView)
}

open class DragDropBehavior : NSObject {
    
    @IBOutlet open var referenceView : UIView! {
        didSet {
            if let referenceView = referenceView {
                animator = UIDynamicAnimator(referenceView: referenceView)
            }
        }
    }
    @IBOutlet open var targetView : UIView! {
        didSet {
            if let targetView = targetView {
                self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DragDropBehavior.handleGesture(_:)))
                targetView.addGestureRecognizer(self.panGestureRecognizer)
            }
        }
    }
    @IBOutlet open weak var delegate : NSObject? // Should really be DragDropBehaviorDelegate but to workaround forming connection issue with protocols
    
    // MARK: UIDynamicAnimator
    fileprivate var animator : UIDynamicAnimator!
    fileprivate var attachmentBehavior : UIAttachmentBehavior!
    fileprivate var gravityBehaviour : UIGravityBehavior!
    fileprivate var snapBehavior : UISnapBehavior!
    open fileprivate(set) var panGestureRecognizer : UIPanGestureRecognizer!
    
    func handleGesture(_ sender: AnyObject) {
        let location = sender.location(in: referenceView)
        let boxLocation = sender.location(in: targetView)
        
        if sender.state == UIGestureRecognizerState.began {
            // animator.removeBehavior(snapBehavior)
            
            let centerOffset = UIOffsetMake(boxLocation.x - targetView.bounds.midX, boxLocation.y - targetView.bounds.midY);
            attachmentBehavior = UIAttachmentBehavior(item: targetView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: targetView, snapTo: referenceView.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translation(in: referenceView)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                let gravity = UIGravityBehavior(items: [targetView])
                gravity.gravityDirection = CGVector(dx: 0, dy: 10)
                animator.addBehavior(gravity)
                
                delay(delay: 0.3) { [weak self] in
                    if let strongSelf = self {
                        (strongSelf.delegate as? DragDropBehaviorDelegate)?.dragDropBehavior(strongSelf, viewDidDrop: strongSelf.targetView)
                    }
                }
            }
        }
    }
}
