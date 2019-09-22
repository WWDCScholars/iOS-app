//
//  HoverBar.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 22.09.19.
//  Copyright © 2019 WWDCScholars. All rights reserved.
//

import UIKit

fileprivate let HoverBarDefaultItemDimension: CGFloat = 44.0

// MARK: - HoverBarOrientation
enum HoverBarOrientation {
    case vertical, horizontal
}

// MARK: - HoverBar
final class HoverBar: UIView {

    typealias Item = AnyObject

    var items: [Item] = [] {
        didSet {
            reloadControls()
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    var orientation: HoverBarOrientation = .horizontal {
        didSet {
            separatorView.orientation = orientation
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    var cornerRadius: CGFloat {
        set {
            backgroundView.clipsToBounds = (newValue != 0)
            backgroundView.layer.cornerRadius = newValue
            shadowLayer.cornerRadius = newValue
        }
        get {
            return backgroundView.layer.cornerRadius
        }
    }
    var borderWidth: CGFloat {
        set {
            backgroundView.layer.borderWidth = newValue
            separatorView.separatorWidth = newValue
        }
        get {
            return backgroundView.layer.borderWidth
        }
    }
    var borderColor: UIColor? {
        set {
            guard let borderColor = newValue else { return }
            backgroundView.layer.borderColor = borderColor.cgColor
            separatorView.separatorColor = borderColor
        }
        get {
            return backgroundView.layer.borderColor != nil ? UIColor(cgColor: backgroundView.layer.borderColor!) : nil
        }
    }
    var shadowRadius: CGFloat {
        set { shadowLayer.shadowRadius = newValue }
        get { return shadowLayer.shadowRadius }
    }
    var shadowOpacity: CGFloat {
        set { shadowLayer.shadowOpacity = Float(newValue) }
        get { return CGFloat(shadowLayer.shadowOpacity) }
    }
    var shadowColor: UIColor? {
        set {
            shadowLayer.shadowColor = newValue != nil ? newValue!.cgColor : nil
        }
        get {
            return shadowLayer.shadowColor != nil ? UIColor(cgColor: shadowLayer.shadowColor!) : nil
        }
    }
    var controls: [UIView] = [] {
        didSet {
            separatorView.viewsToSeparate = controls
        }
    }
    var itemsControlsMap: NSMapTable<UIControl, Item> = NSMapTable.weakToWeakObjects()

    // Subviews
    var backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    var separatorView = HoverBarSeparatorView()
    var shadowLayer = HoverBarShadowLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = .clear

        // add shadow layer
        layer.addSublayer(shadowLayer)

        // add visual effect view as background
        addSubview(backgroundView)

        // add separator drawing view on top
        addSubview(separatorView)

        // set default values
        borderColor = .lightGray
        borderWidth = 1.0 / UIScreen.main.scale
        cornerRadius = 8.0
        shadowOpacity = 0.25
        shadowColor = .black
        shadowRadius = 6.0
    }

    // MARK: - Layout

    override var intrinsicContentSize: CGSize {
        let itemLength = HoverBarDefaultItemDimension * CGFloat(items.count)

        switch orientation {
        case .vertical:
            return CGSize(width: HoverBarDefaultItemDimension, height: itemLength)
        case .horizontal:
            return CGSize(width: itemLength, height: HoverBarDefaultItemDimension)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var yStep: CGFloat = 0.0
        var xStep: CGFloat = 0.0
        backgroundView.frame = bounds
        separatorView.frame = bounds
        shadowLayer.frame = bounds

        switch orientation {
        case .vertical:
            yStep = HoverBarDefaultItemDimension
            break
        case .horizontal:
            xStep = HoverBarDefaultItemDimension
        }

        var frame = CGRect(x: 0, y: 0, width: HoverBarDefaultItemDimension, height: HoverBarDefaultItemDimension)

        for control in controls {
            control.frame = frame
            frame = frame.offsetBy(dx: xStep, dy: yStep)
        }
    }

    // MARK: - Control management

    func reloadControls() {
        resetControls()
        var controls: [UIView] = []

        for item in items {
            let control: UIControl
            if let barButtonItem = item as? UIBarButtonItem, let c = newControl(forBarButtonItem: barButtonItem) {
                control = c
            } else if let buttonItem = item as? UIButton {
                control = buttonItem
            } else if let viewItem = item as? UIView {
                addSubview(viewItem)
                controls.append(viewItem)
                continue
            } else {
                continue
            }

            addSubview(control)
            controls.append(control)
            itemsControlsMap.setObject(item, forKey: control)
        }

        self.controls = controls
    }

    func newControl(forBarButtonItem item: UIBarButtonItem) -> UIControl? {
        if let customView = item.customView as? UIControl {
            customView.tintColor = item.tintColor
            return customView
        }

        if item.image == nil && item.title == nil {
            assert((item.image != nil || item.title != nil),
                "HoverBar only supports bar button items with an image, title or customView (of type UIControl). " +
                "If you attempted to use a system item, please consider creating your own artwork.")
            return nil
        }

        let button = UIButton(type: .system)
        if let image = item.image {
            button.setImage(image, for: .normal)
        }

        if let title = item.title {
            button.setTitle(title, for: .normal)
        }

        if let tintColor = item.tintColor {
            button.tintColor = tintColor
        }

        button.addTarget(self, action: #selector(handleAction(forControl:)), for: .touchUpInside)

        return button
    }

    @objc
    func handleAction(forControl control: UIControl) {
        guard let item = itemsControlsMap.object(forKey: control) else { return }
        if let barButtonItem = item as? UIBarButtonItem {
            guard let target = barButtonItem.target,
                let action = barButtonItem.action
                else { return }
            target.performSelector(inBackground: action, with: barButtonItem)
        } else if let buttonItem = item as? UIButton {
            buttonItem.sendActions(for: .touchUpInside)
        }
    }

    func resetControls() {
        for control in controls {
            control.removeFromSuperview()
        }

        controls = []
        itemsControlsMap.removeAllObjects()
    }

}

