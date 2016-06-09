//
//  UIImage+Cropping.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 09/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

extension UIImage {
    static func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        } else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth: CGFloat = CGFloat(CGImageGetWidth(image.CGImage))
        let refHeight: CGFloat = CGFloat(CGImageGetHeight(image.CGImage))
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRectMake(x, y, size.height, size.width)
        if let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect) {
            return UIImage(CGImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
}