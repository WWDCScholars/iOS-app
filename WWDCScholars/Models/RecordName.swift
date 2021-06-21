//
//  RecordName.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 17.06.21.
//

struct RecordName {
    let value: String

    init(_ value: String) {
        self.value = value
    }
}

extension RecordName: Identifiable {
    var id: String { value }
}

extension RecordName: Equatable {}
