//
//  Sequence+sorted.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { lhs, rhs in
            lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
        }
    }
}
