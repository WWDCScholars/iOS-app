//
//  UIImage+Named.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 03.06.18.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import UIKit

internal extension UIImage {
    
    internal static var loading: UIImage {
        return UIImage(named: "loading") ?? UIImage()
    }
    
}
