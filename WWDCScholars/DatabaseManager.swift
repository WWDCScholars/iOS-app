//
//  DatabaseManager.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    let realm: Realm!
    
    /// Shared instance of DatabaseManager, whose database is the default Realm
    static let sharedInstance = DatabaseManager()
    
    private init() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
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
    func addScholar(scholar: Scholar) {
        try! realm.write {
            realm.add(scholar, update: true) // Don't add the scholar if he/she already exists
        }
        print ("Added \(scholar.fullName)")
    }
    
    /**
     Gets a list of all scholars which are currently in the database
     
     - returns: List of scholars
     */
    func getAllScholars() -> [Scholar] {
        let scholars = realm.objects(Scholar)
        return Array(scholars)
    }
    
    /**
     Returns the amount of scholars which are currently in the database
     
     - returns: Number of scholars
     */
    func scholarCount() -> Int {
        let scholars = realm.objects(Scholar)
        return scholars.count
    }
    
    /**
     Returns a scholar for the provided id. Which might be nil if the scholar is currently not in the local database
     
     - parameter id: The id of the scholar
     
     - returns: The (optional) scholar for the id
     */
    func scholarForId(id: String) -> Scholar? {
        return realm.objectForPrimaryKey(Scholar.self, key: id)
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