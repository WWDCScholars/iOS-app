//
//  RandomAccessCollection+subscript-safe.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 26.03.22.
//

extension RandomAccessCollection {
    subscript(safe index: Index) -> Element? {
        guard index >= startIndex , index < endIndex else { return nil }
        return self[index]
    }
}
