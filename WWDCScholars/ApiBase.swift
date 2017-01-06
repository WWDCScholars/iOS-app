//
//  ApiBase.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 11/05/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
class ApiBase {
    
    /// Server URL of the database (with API) where the scholar data is saved
    var serverUrl: URL = ""
    var apiKey: String = ""
    
    func setServerDetails(_ serverUrl: URL, serverAPIKey: String) {
        self.serverUrl = serverUrl
        self.apiKey = serverAPIKey
    }
    
    class func setServerDetails(_ serverUrl: URL, serverAPIKey: String) {
        ScholarsKit.sharedInstance.setServerDetails(serverUrl, serverAPIKey: serverAPIKey)
        BlogKit.sharedInstance.setServerDetails(serverUrl, serverAPIKey: serverAPIKey)
        UserKit.sharedInstance.setServerDetails(serverUrl, serverAPIKey: serverAPIKey)
    }
}
