//
//  TutorialObject.swift
//  WWDCIntroview
//
//  Created by Alex Zimin on 28/05/15.
//  Copyright (c) 2015 WWDC-Scholars. All rights reserved.
//

import UIKit

private var screenSize: CGSize {
    return UIScreen.main.bounds.size
}

enum TutorialObjectActionType {
    case changeAlpha
    case resize
}

enum TutorialObjectAction: Equatable {
    case changeAlpha(value: CGFloat)
    case resize(size: CGSize)
    
    var intValue: Int {
        switch self {
        case .changeAlpha(value: _):
            return 0
        case .resize(size: _):
            return 1
        }
    }
    
    func applyAction(_ object: UIView) {
        switch self {
        case let .changeAlpha(value: value):
            object.alpha = value
        case let .resize(size: value):
            let center = object.center
            object.frame = CGRect(x: 0, y: 0, width: value.width, height: value.height)
            object.center = center
        }
    }
    
    func merge(_ another: TutorialObjectAction, delta: CGFloat) -> TutorialObjectAction {
        switch (self, another) {
        case let (.changeAlpha(value: value), .changeAlpha(value: anotherValue)):
            return TutorialObjectAction.changeAlpha(value: value + (anotherValue - value) * delta)
        case let (.resize(size: value), .resize(size: anotherValue)):
            let size = CGSize(width: value.width + (anotherValue.width - value.width) * delta, height: value.height + (anotherValue.height - value.height) * delta)
            return TutorialObjectAction.resize(size: size)
        default:
            return .changeAlpha(value: 1.0)
        }
    }
}

class TutorialObjectActionContainer {
    class func findOrCreateAction(_ type: TutorialObjectActionType, actions: [TutorialObjectAction]) -> TutorialObjectAction {
        var action: TutorialObjectAction
        switch type {
        case .changeAlpha:
            action = TutorialObjectAction.changeAlpha(value: 1.0)
        case .resize:
            action = TutorialObjectAction.resize(size: CGSize.zero)
        }
        
        if let index = actions.index(of: action) {
            return actions[index]
        }
        
        return action
    }
}

func ==(lhs: TutorialObjectAction, rhs: TutorialObjectAction) -> Bool {
    return lhs.intValue == rhs.intValue
}

class TutorialObject {
    var object: UIView!
    fileprivate(set) var points: [CGPoint] = []
    var tag = 0
    
    fileprivate(set) var size: CGSize = CGSize.zero
    fileprivate var startPosition: CGPoint = CGPoint.zero
    
    fileprivate var actions: [Int: [TutorialObjectAction]] = [:]
    
    init(object: UIView) {
        self.object = object
        self.actions[0] = [TutorialObjectAction.changeAlpha(value: object.alpha), TutorialObjectAction.resize(size: object.frame.size)]
        startPosition = object.center
    }
    
    var shouldAutoconvert: Bool = true
    
    func setSize(_ size: CGSize) {
        needToRecalculateActions = true
        
        if shouldAutoconvert {
            self.size = CGSize(width: screenSize.width * size.width, height: screenSize.height * size.height)
        } else {
            self.size = screenSize
        }
        
        self.actions[0] = [TutorialObjectAction.changeAlpha(value: object.alpha), TutorialObjectAction.resize(size: self.size)]
    }
    
    func setPoints(_ points: [CGPoint]) {
        needToRecalculateActions = true
        
        self.points = []
        if shouldAutoconvert {
            for point in points {
                self.points.append(CGPoint(x: point.x * screenSize.width, y: point.y * screenSize.height))
            }
        } else {
            self.points = points
        }
    }
    
    func addActionAtPosition(_ action: TutorialObjectAction, position: Int) {
        needToRecalculateActions = true
        
        if actions[position] == nil {
            actions[position] = []
        }
        
        if let index = actions[position]!.index(of: action) {
            actions[position]?.remove(at: index)
        }
        
        actions[position]?.append(action)
    }
    
    fileprivate var needToRecalculateActions = true
    fileprivate func recalculateActions() {
        let count = points.count
        
        var preveousAlphaAction = actions[0]![0]
        var preveousSizeAction = actions[0]![1]
        
        for i in 1..<count {
            if actions[i] == nil {
                actions[i] = []
            }
            
            if let index = actions[i]!.index(of: preveousAlphaAction) {
                preveousAlphaAction = actions[i]![index]
            } else {
                addActionAtPosition(preveousAlphaAction, position: i)
            }
            
            if let index = actions[i]!.index(of: preveousSizeAction) {
                preveousSizeAction = actions[i]![index]
            } else {
                addActionAtPosition(preveousSizeAction, position: i)
            }
        }
    }
    
    func actionsAtPosition(_ position: Int) -> [TutorialObjectAction] {
        return actions[position] ?? []
    }
    
    func changeObjectToPosition(_ position: CGPoint) {
        var newPosition = position
        
        newPosition.x += startPosition.x
        
        if needToRecalculateActions {
            recalculateActions()
            needToRecalculateActions = false
        }
        
        if points.count == 0 {
            return
        }
        
        var index = -1
        for point in points {
            if point.x >= newPosition.x {
                break
            }
            index += 1
        }
        
        if index == -1 {
            object.center = points[0]
            //let currentActions = actionsAtPosition(0)
            //currentActions.map({ $0.applyAction(self.object) })
        } else if index + 1 == points.count {
            object.center = points[points.count - 1]
            //let currentActions = actionsAtPosition(index)
            //currentActions.map({ $0.applyAction(self.object) })
        } else {
            let firstPoint = points[index]
            let secondPoint = points[index + 1]
            let delta = 1 - (secondPoint.x - newPosition.x) / (secondPoint.x - firstPoint.x)
            
            object.center = CGPoint(x: firstPoint.x + (secondPoint.x - firstPoint.x) * delta, y: firstPoint.y + (secondPoint.y - firstPoint.y) * delta)
            
            let oldActions = actionsAtPosition(index)
            let newActions = actionsAtPosition(index + 1)
            
            let alphaAction = TutorialObjectActionContainer.findOrCreateAction(.changeAlpha, actions: oldActions).merge(TutorialObjectActionContainer.findOrCreateAction(.changeAlpha, actions: newActions), delta: delta)
            let frameAction = TutorialObjectActionContainer.findOrCreateAction(.resize, actions: oldActions).merge(TutorialObjectActionContainer.findOrCreateAction(.resize, actions: newActions), delta: delta)
            
            
            alphaAction.applyAction(self.object)
            frameAction.applyAction(self.object)
        }
        
    }
}
