//
//  HoverBarSeparatorView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 22.09.19.
//  Copyright © 2019 WWDCScholars. All rights reserved.
//

import UIKit

final class HoverBarSeparatorView: UIView {
    public var orientation: HoverBarOrientation = .horizontal {
        didSet { setNeedsDisplay() }
    }
    public var separatorColor: UIColor {
        didSet { setNeedsDisplay() }
    }
    public var separatorWidth: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    public var viewsToSeparate: [UIView] = [] {
        didSet { setNeedsDisplay() }
    }

    init() {
        if #available(iOS 13.0, *) {
            separatorColor = .systemGray2
        } else {
            separatorColor = .lightGray
        }
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        separatorColor.setStroke()
        ctx.setLineWidth(separatorWidth)

        let xMax = rect.width
        let yMax = rect.height
        // offset separator position by half the separator width to draw on physical pixels
        // if the separator width is below 1pt
        let separatorOffset = separatorWidth < 1 ? separatorWidth / 2.0 : 0

        for view in viewsToSeparate {
            if view == viewsToSeparate.last {
                break // no separator after last view
            }

            // draw separator after view
            // Convert frame to this coordinate space
            let viewFrame = view.convert(view.bounds, to: self)
            var from: CGPoint, to: CGPoint

            switch orientation {
            case .vertical:
                let y = viewFrame.maxY + separatorOffset
                from = CGPoint(x: 0, y: y)
                to = CGPoint(x: xMax, y: y)
                break
            case .horizontal:
                let x = viewFrame.maxX + separatorOffset
                from = CGPoint(x: x, y: 0)
                to = CGPoint(x: x, y: yMax)
                break
            }

            ctx.move(to: from)
            ctx.addLine(to: to)
            ctx.strokePath()
        }
    }
}

