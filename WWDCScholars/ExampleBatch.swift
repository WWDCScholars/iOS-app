//
//  ExampleBatch.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class BatchInfo {
    
    // MARK: - Internal Properties
    
    internal static let wwdc2013Key = "WWDC 2013"
    internal static let wwdc2014Key = "WWDC 2014"
    internal static let wwdc2015Key = "WWDC 2015"
    internal static let wwdc2016Key = "WWDC 2016"
    internal static let wwdc2017Key = "WWDC 2017"
    internal static let savedKey = "Saved"
}

internal protocol ExampleBatch: class {
    var title: String { get }
    var isDefault: Bool { get set }
    var recordName: String { get }
}

internal class Batch2013: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2013"
    internal let recordName = BatchInfo.wwdc2013Key
    
    internal var isDefault = false
}

internal class Batch2014: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2014"
    internal let recordName = BatchInfo.wwdc2014Key
    
    internal var isDefault = false
}

internal class Batch2015: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2015"
    internal let recordName = BatchInfo.wwdc2015Key
    
    internal var isDefault = false
}

internal class Batch2016: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2016"
    internal let recordName = BatchInfo.wwdc2016Key
    
    internal var isDefault = false
}

internal class Batch2017: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "2017"
    internal let recordName = BatchInfo.wwdc2017Key
    
    internal var isDefault = true
}

internal class BatchSaved: ExampleBatch {
    
    // MARK: - Internal Properties
    
    internal let title = "Saved"
    internal let recordName = BatchInfo.savedKey
    
    internal var isDefault = false
}
