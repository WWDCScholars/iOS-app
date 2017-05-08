//
//  TextHeightSwift.swift
//  TagsView
//
//  Created by Alex Zimin on 03/05/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import Foundation
import UIKit

class AZTextFrameAttributes {
    // Basic info
    fileprivate(set) var width: CGFloat = 0
    fileprivate(set) var string: String?
    fileprivate(set) var attributedString: NSAttributedString?
    
    // Text Info
    var attributes: [AnyHashable: Any] = [:]
    var lineBreakingMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping {
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
        self.attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
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
    fileprivate let attributes: AZTextFrameAttributes
    fileprivate(set) var width: CGFloat = 0
    fileprivate(set) var height: CGFloat = 0
    
    init(attributes: AZTextFrameAttributes) {
        self.attributes = attributes
        calculate()
    }
    
    fileprivate func calculate() {
        let sizeForHeight = CGSize(width: attributes.width - 2, height: CGFloat.greatestFiniteMagnitude)
        let sizeForWidth = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        if let string = attributes.string {
            height = (string as NSString).boundingRect(with: sizeForHeight, options: .usesLineFragmentOrigin, attributes: attributes.attributes as? [String: AnyObject], context: nil).height + 2
            width = (string as NSString).boundingRect(with: sizeForWidth, options: .usesLineFragmentOrigin, attributes: attributes.attributes as? [String: AnyObject], context: nil).width + 2
        } else if let attributedString = attributes.attributedString {
            height = attributedString.boundingRect(with: sizeForHeight, options: .usesLineFragmentOrigin, context: nil).height
            width = attributedString.boundingRect(with: sizeForWidth, options: .usesLineFragmentOrigin, context: nil).width
        }
    }
}
