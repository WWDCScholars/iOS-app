//
//  Logger+subsystem.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 19.06.21.
//

import OSLog

extension Logger {
    static func subsystem(_ label: String) -> String {
        "\(Bundle.main.bundleIdentifier ?? "unknown").\(label)"
    }
}
