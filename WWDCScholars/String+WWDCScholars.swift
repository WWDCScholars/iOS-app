//
//  String+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 05/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - Functions
    
    func height(for width: CGFloat, font: UIFont?) -> CGFloat {
        guard let font = font else {
            return 0.0
        }
        
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return actualSize.height
    }
}
