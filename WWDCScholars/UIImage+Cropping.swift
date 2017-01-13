//
//  UIImage+Cropping.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 09/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

extension UIImage {
    static func cropImageToSquare(_ image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        } else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth: CGFloat = CGFloat(image.cgImage!.width)
        let refHeight: CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
}
