//
//  BlogPost.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 03/06/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal class BlogPost: CloudKitInitializable {
    internal var id: CKRecordID
    
    internal var title: String
    internal var content: String
    internal var headerImage: CKAsset
    internal var tags: [String]
    internal var author: CKReference
    
    internal required init(record: CKRecord) {
        id = record.recordID
        title = record["title"] as! String
        content = record["content"] as! String
        headerImage = record["headerImage"] as! CKAsset
        tags = record["tags"] as! [String]
        author = record["author"] as! CKReference
    }
}
