//
//  ImageManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ImageManager {
    static let sharedInstance = ImageManager()
    
    func expandImage(imageView: UIImageView, viewController: UIViewController) {
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageView.image
        imageInfo.referenceRect = imageView.frame
        imageInfo.referenceView = imageView.superview
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Blurred)
        imageViewer.showFromViewController(viewController, transition: .FromOriginalPosition)
    }
}
