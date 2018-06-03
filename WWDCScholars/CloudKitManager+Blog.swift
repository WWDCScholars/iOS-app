//
//  CloudKitManager+Blog.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 03/06/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal typealias BlogPostLoaded = ((BlogPost) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadBlogPosts(cursor: CKQueryCursor? = nil, recordFetched: @escaping BlogPostLoaded, completion: QueryCompletion) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "BlogPost", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperationMaximumResults
        operation.cursor = cursor
        operation.qualityOfService = .userInteractive
        
        operation.queryCompletionBlock = completion
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
            let blogPost = BlogPost.init(record: record)
            recordFetched(blogPost)
        }
        
        self.database.add(operation)
    }
}
