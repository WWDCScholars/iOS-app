//
//  Logger+InitCategory.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 19.06.21.
//

import OSLog

extension Logger {
    init(subsystem: String, category: Logger.Category) {
        self.init(subsystem: subsystem, category: category.rawValue)
    }
}
