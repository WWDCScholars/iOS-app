//
//  ExampleBatch.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation

internal protocol ExampleBatch {
    var title: String { get }
}

internal struct BatchEarlier: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "Earlier"
}

internal struct Batch2014: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2014"
}

internal struct Batch2015: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2015"
}

internal struct Batch2016: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2016"
}

internal struct Batch2017: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2017"
}
