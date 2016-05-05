//
//  TextHeightSwift.swift
//  TagsView
//
//  Created by Alex Zimin on 03/05/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import Foundation

class AZTextFrameAttributes {
    // Basic info
    private(set) var width: CGFloat = 0
    private(set) var string: String?
    private(set) var attributedString: NSAttributedString?
    
    // Text Info
    var attributes: [NSObject: AnyObject] = [:]
    var lineBreakingMode: NSLineBreakMode = NSLineBreakMode.ByWordWrapping {
        didSet {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = lineBreakingMode
            attributes[NSParagraphStyleAttributeName] = paragraph
        }
    }
    
    init(string: String) {
        self.string = string
    }
    
    init(string: String, font: UIFont) {
        self.string = string
        self.attributes = [NSFontAttributeName: font]
    }
    
    init(string: String, width: CGFloat) {
        self.string = string
        self.width = width
        self.attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18)]
    }
    
    init(string: String, width: CGFloat, font: UIFont) {
        self.string = string
        self.width = width
        self.attributes = [NSFontAttributeName: font]
    }
    
    init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
}

class AZTextFrame {
    private let attributes: AZTextFrameAttributes
    private(set) var width: CGFloat = 0
    private(set) var height: CGFloat = 0

    init(attributes: AZTextFrameAttributes) {
        self.attributes = attributes
        calculate()
    }
    
    private func calculate() {
        let sizeForHeight = CGSize(width: attributes.width - 2, height: CGFloat.max)
        let sizeForWidth = CGSize(width: CGFloat.max, height: CGFloat.max)
        
        if let string = attributes.string {
            height = (string as NSString).boundingRectWithSize(sizeForHeight, options: .UsesLineFragmentOrigin, attributes: attributes.attributes as? [String: AnyObject], context: nil).height + 2
            width = (string as NSString).boundingRectWithSize(sizeForWidth, options: .UsesLineFragmentOrigin, attributes: attributes.attributes as? [String: AnyObject], context: nil).width + 2
        } else if let attributedString = attributes.attributedString {
            height = attributedString.boundingRectWithSize(sizeForHeight, options: .UsesLineFragmentOrigin, context: nil).height
            width = attributedString.boundingRectWithSize(sizeForWidth, options: .UsesLineFragmentOrigin, context: nil).width
        }
    }
}