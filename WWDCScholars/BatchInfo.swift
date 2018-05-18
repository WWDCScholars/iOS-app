//
//  BatchInfo.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class BatchKey {
    
    // MARK: - Internal Properties
    
    internal static let wwdc2013 = "WWDC 2013"
    internal static let wwdc2014 = "WWDC 2014"
    internal static let wwdc2015 = "WWDC 2015"
    internal static let wwdc2016 = "WWDC 2016"
    internal static let wwdc2017 = "WWDC 2017"
	internal static let wwdc2018 = "WWDC 2018"
    internal static let saved = "Saved"
}

internal protocol BatchInfo: class {
    var title: String { get }
    var isDefault: Bool { get set }
    var recordName: String { get }
}

internal class BatchInfo2013: BatchInfo {
    
    // MARK: - Internal Properties
    
    internal let title = "2013"
    internal let recordName = BatchKey.wwdc2013
    
    internal var isDefault = false
}

internal class BatchInfo2014: BatchInfo  {
    
    // MARK: - Internal Properties
    
    internal let title = "2014"
    internal let recordName = BatchKey.wwdc2014
    
    internal var isDefault = false
}

internal class BatchInfo2015: BatchInfo  {
    
    // MARK: - Internal Properties
    
    internal let title = "2015"
    internal let recordName = BatchKey.wwdc2015
    
    internal var isDefault = false
}

internal class BatchInfo2016: BatchInfo {
    
    // MARK: - Internal Properties
    
    internal let title = "2016"
    internal let recordName = BatchKey.wwdc2016
    
    internal var isDefault = false
}

internal class BatchInfo2017: BatchInfo  {
    
    // MARK: - Internal Properties
    
    internal let title = "2017"
    internal let recordName = BatchKey.wwdc2017
    
    internal var isDefault = true
}

internal class BatchInfo2018: BatchInfo  {
	
	// MARK: - Internal Properties
	
	internal let title = "2018"
	internal let recordName = BatchKey.wwdc2018
	
	internal var isDefault = true
}

internal class BatchInfoSaved: BatchInfo  {
    
    // MARK: - Internal Properties
    
    internal let title = "Saved"
    internal let recordName = BatchKey.saved
    
    internal var isDefault = false
}
