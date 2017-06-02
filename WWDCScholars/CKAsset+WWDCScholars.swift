//
//  CKAsset+WWDCScholars.swift
//  WWDCScholars-Manager
//
//  Created by Matthijs Logemann on 25/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

internal extension CKAsset {
    
    // MARK: - Internal Properties
    
    internal var image: UIImage? {
        if let data = try? Data(contentsOf: self.fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
}
