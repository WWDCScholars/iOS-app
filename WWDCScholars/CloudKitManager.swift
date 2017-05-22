//
//  CloudKitManager.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 22/05/2017.
//  Copyright © 2017 Matthijs Logemann. All rights reserved.
//

import Foundation
import CloudKit

internal final class CloudKitManager {
    
    // MARK: - Internal Properties
    
    internal static let shared = CloudKitManager()
    internal let container: CKContainer
    
    // MARK: - Public Properties
    
    public let database: CKDatabase
    
    // MARK: - Lifecycle
    
    private init() {
        container = CKContainer.init(identifier: "iCloud.com.wwdcscholars.WWDCScholars")
        database = container.publicCloudDatabase
    }
    
    // MARK: - Internal Functions
    
    // MARK: - Private Functions
    
    
}
