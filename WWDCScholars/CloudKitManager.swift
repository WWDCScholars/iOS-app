//
//  CloudKitManager.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 22/05/2017.
//  Copyright © 2017 Matthijs Logemann. All rights reserved.
//

import Foundation
import CloudKit

internal typealias RecordFetched = (CKRecord) -> Void
internal typealias QueryCompletion = ((CKQueryCursor?, Error?) -> Void)?

internal final class CloudKitManager {
    
    // MARK: - Internal Properties
    
    internal static let shared = CloudKitManager()
    internal let container: CKContainer
    
    // MARK: - Public Properties
    
    public let database: CKDatabase
    
    // MARK: - Lifecycle
    
    private init() {
        self.container = CKContainer(identifier: "iCloud.com.wwdcscholars.WWDCScholars")
        self.database = self.container.publicCloudDatabase
    }
}
