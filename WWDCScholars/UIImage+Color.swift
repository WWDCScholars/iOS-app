//
//  UIImage+Color.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithSize(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextFillRect(context, CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}