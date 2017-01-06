//
//  BlogKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 07/05/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import Alamofire

class BlogKit: ApiBase {
    static let sharedInstance = BlogKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    fileprivate override init() {
    }
    
    /**
     Loads scholars from the online database
     */
    func loadPosts(_ completionHandler: @escaping () -> Void) {
        Alamofire.request("\(self.serverUrl)/api/posts/\(self.apiKey)")
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
    
    func parsePosts(_ jsonArr: [JSON]) {
        for postJson in jsonArr {
            if let post = parsePost(postJson) {
                dbManager.addBlogPost(post)
            }else {
                print("BlogPost (with id \(postJson["_id"].string)) missing items!")
            }
        }
    }
    
    func parsePost(_ json: JSON) -> BlogPost? {
        if
            let postId = json["_id"].string,

            let title = json["title"].string,
            let headerImage = json["headerImage"].string,
            let content = json["content"].string,
            
            //author related
            let email = json["email"].string,
//            let scholarLink = json["scholarLink"].string,
            let scholarName = json["scholarName"].string,
            
            //for sharing purposes using social media buttons
            let urlLink = json["links"]["link"].string,
            
            //other info
            let updatedAt = json["updateAt"].string,
            let createdAt = json["createdAt"].string {
            
            let newPost = BlogPost()
            
            newPost.postId = postId
            newPost.scholarId = json["scholarId"].string
            newPost.email = email
            newPost.content = content
            newPost.title = title
            newPost.scholarLink = json["scholarLink"].string?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!.replacingOccurrences(of: "%3A", with: ":")
            newPost.scholarName = scholarName
            newPost.headerImage = headerImage.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!.replacingOccurrences(of: "%3A", with: ":")
            newPost.urlLink = urlLink
            
            //guest author related
            newPost.guestLink = json["guestLink"].string //Optional - Guest Link
            
            newPost.updatedAt = updatedAt.date(inFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
            newPost.createdAt = createdAt.date(inFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
            newPost.tags = json["tags"].array!.map({return $0.string!})
            
            return newPost
            
        } else {
            return nil
        }
    }
    
}
