//
//  CKAsset+image.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 29.07.21.
//

import CloudKit
import UIKit

extension CKAsset {
    var image: UIImage? {
        guard let fileURL = fileURL,
              let data = try? Data(contentsOf: fileURL)
        else { return nil }

        return UIImage(data: data)
    }
}
