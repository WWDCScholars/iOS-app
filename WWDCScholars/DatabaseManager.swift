//
//  DatabaseManager.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import RealmSwift

typealias Scholars = [Scholar]
class DatabaseManager {
    let realm: Realm!
    
    /// Shared instance of DatabaseManager, whose database is the default Realm
    static let sharedInstance = DatabaseManager()
    
    fileprivate init() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 17,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                //                if (oldSchemaVersion == 3) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
                migration.deleteData(forType: "Scholar")
                //                }
        })
        
        realm = try! Realm(configuration: config)
    }
    
    /**
     Initializer for use with a different Realm (for example for Unit Testing)
     
     - parameter realm: Realm used to setup this DatabaseManager
     
     - returns: DatabaseManager
     */
    init(realm: Realm) {
        self.realm = realm
    }
    
    /**
     Add a scholar to the local Realm
     
     - parameter scholar: Scholar which will be added to the database
     */
    func addScholar(_ scholar: Scholar) {
        try! realm.write {
            realm.add(scholar, update: true) // Don't add the scholar if he/she already exists
        }
        //print ("Added \(scholar.fullName)")  // Sorry but I don't care at all about this. I want a clean console, thx.
    }
    
    func addRealmObject(_ obj: Object, update: Bool = false) {
        try! realm.write {
            realm.add(obj, update: update) // Don't add the scholar if he/she already exists
        }
        //print ("Added \(scholar.fullName)")  // Sorry but I don't care at all about this. I want a clean console, thx.
    }
    
    /**
     Add a list of scholars to the local Realm
     
     - parameter scholars: Scholar which will be added to the database
     */
    func addScholars(_ scholars: [Scholar]) {
        try! realm.write {
            for scholar in scholars {
                realm.add(scholar, update: true) // Don't add the scholar if he/she already exists
            }
        }
        //print ("Added \(scholar.fullName)")  // Sorry but I don't care at all about this. I want a clean console, thx.
    }
    
    /**
     Gets a list of all scholars which are currently in the database
     
     - returns: List of scholars
     */
    func getAllScholars() -> [Scholar] {
        let scholars = realm.objects(Scholar.self)
        return Array(scholars)
    }
    
    /**
     Returns the amount of scholars which are currently in the database
     
     - returns: Number of scholars
     */
    func scholarCount() -> Int {
        let scholars = realm.objects(Scholar.self)
        return scholars.count
    }
    
    /**
     Returns a scholar for the provided id. Which might be nil if the scholar is currently not in the local database
     
     - parameter id: The id of the scholar
     
     - returns: The (optional) scholar for the id
     */
    func scholarForId(_ id: String) -> Scholar? {
        return realm.object(ofType: Scholar.self, forPrimaryKey: id as AnyObject)
    }
    
    func scholarsForWWDCBatch(_ wwdc: WWDC) -> Scholars {
        let predicate = NSPredicate(format: "ANY batches.batchWWDCStr == %@", wwdc.toRawValue())
        return Array(realm.objects(Scholar.self).filter(predicate).sorted(byKeyPath: "firstName"))
    }
    
    /**
     Add a blogpost to the local database (or Realm)
     
     - parameter post: The blog post to add
     */
    func addBlogPost(_ post: BlogPost) {
        try! realm.write {
            realm.add(post, update: true) // Don't add the blog post if it already exists
        }
        print ("Added post \"\(post.title)\"")
    }
    
    /**
     Gets a list of all BlogPosts which are currently in the database
     
     - returns: List of BlogPosts
     */
    func getAllBlogPosts() -> [BlogPost] {
        let posts = realm.objects(BlogPost.self).sorted(byKeyPath: "createdAt", ascending: false)
        return Array(posts)
    }
    
    /**
     Removes all scholars from the current Realm. Use with caution!
     */
    func deleteAllScholars() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
