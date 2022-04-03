//
//  configure.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 03.04.22.
//

func configure<T>(_ object: T, using closure: (inout T) -> Void) -> T {
    var object = object
    closure(&object)
    return object
}
