//
//  UIImage+estimatedSize.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 04.04.21.
//

import UIKit

extension UIImage {
    /// Estimated size of the image, used for caching.
    var estimatedSizeInKB: Int {
        let bytesPerRow = Int(size.width * scale) * 4
        let numberOfRows = Int(size.height * scale)
        return bytesPerRow / 1024 * numberOfRows
    }
}
