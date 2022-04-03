//
//  GrammaticalNumber+initWithExactNumber.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 03.04.22.
//

import Foundation

extension Morphology.GrammaticalNumber {
    init(exactNumber: Int) {
        // seems to work weird for english if we use the correct cases
        if exactNumber == 1 {
            self = .singular
        } else {
            self = .plural
        }
    }
}
