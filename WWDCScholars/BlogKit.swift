//
//  BlogKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 07/05/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
class BlogKit {
    static let sharedInstance = BlogKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    private init() {
    }
    
    /**
     Loads scholars from the online database
     */
    func loadPosts(completionHandler: () -> Void) {
        request(.GET, "https://wwdcscholarsadmin.herokuapp.com/api/posts")
            .responseString() { response in
                if let data = response.result.value {
                    //                print (data)
                    let json = JSON.parse(data)
                    //                print("JSON: \(json)")
                    if let array = json.array {
                        self.parsePosts(array)
                        completionHandler()
                    }
                }
        }
    }
    
    func parsePosts(jsonArr: [JSON]) {
        for postJson in jsonArr {
            if let post = parsePost(postJson) {
                dbManager.addBlogPost(post)
            }else {
                print("BlogPost (with id \(postJson["_id"].string)) missing items!")
            }
        }
    }
    
    func parsePost(json: JSON) -> BlogPost? {
        if let id = json["_id"].string,
            let email = json["email"].string,
            let scholarLink = json["scholarLink"].string,
            let scholarName = json["scholarName"].string,
            let videoLink = json["videoLink"].string,
            let content = json["content"].string,
            let title = json["title"].string,
            let image = json["images"].string,
            let updatedAt = json["updateAt"].string,
            let createdAt = json["createdAt"].string {
            
            let newPost = BlogPost()
            newPost.id = id
            newPost.email = email
            newPost.content = content
            newPost.title = title
            newPost.scholarLink = scholarLink //todo is optional?
            newPost.scholarName = scholarName
            newPost.imageUrl = image
            newPost.videoLink = videoLink
            newPost.updatedAt = updatedAt.dateFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
            newPost.createdAt = createdAt.dateFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
            newPost.tags = json["tags"].array!.map({return $0.string!})
            return newPost
        }else {
            return nil
        }
    }

}