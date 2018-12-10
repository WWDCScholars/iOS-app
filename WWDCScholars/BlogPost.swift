//
//  BlogPost.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 03/06/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal class BlogPost {
    internal var id: UUID
    
    internal var title: String
    internal var content: String
    internal var headerImageUrl: URL
    internal var tags: [String]
    internal var author: UUID?
    
    internal required init(record: [String: Any]) {
        id = record["id"] as! UUID
        title = record["title"] as! String
        content = record["content"] as! String
        headerImageUrl = record["headerImage"] as! URL
        tags = record["tags"] as! [String]
        author = record["author"] as? UUID
    }
}
