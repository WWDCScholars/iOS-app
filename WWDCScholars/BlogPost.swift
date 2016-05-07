//
//  BlogPost.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 07/05/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import RealmSwift

class BlogPost : Object {
    /// The ID of the blog post
    dynamic var id: String = ""
    
    dynamic var email: String = ""
    
    dynamic var scholarName: String = ""
    
    dynamic var scholarLink: String? = nil
    
    dynamic var videoLink: String? = ""
    
    dynamic var content: String = ""
    
    dynamic var title: String = ""
    
    dynamic var imageUrl: String = ""
    
    dynamic var createdAt: NSDate = NSDate.today()
    dynamic var updatedAt: NSDate = NSDate.today()
    
    private dynamic var tagsString: String = ""
    /// Array of WWDC's the scholar has been to
    var tags: [String] {
        set {
            var strArr: [String] = []
            let arr: [String] = newValue
            for str in arr {
                strArr.append(str)
            }
            tagsString = strArr.joinWithSeparator("|")
        }
        
        get {
            let strArr = tagsString.componentsSeparatedByString("|")
            var arr: [String] = []
            for str in strArr {
                arr.append(str)
            }
            return arr.reverse()
        }
    }

    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["tags"]
    }
}