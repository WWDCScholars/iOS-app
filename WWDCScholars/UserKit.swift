//
//  UserKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 28/05/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import CryptoSwift

class UserKit: ApiBase {
    static let sharedInstance = UserKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    private override init() {
    }
    
    var isLoggedIn: Bool {
        return scholarId != "" && scholarId != nil
    }
    
    var scholarId: String? {
        get {
            if let scholarId = NSUserDefaults.standardUserDefaults().stringForKey("scholarId") {
                if scholarId == "" {
                    return nil
                }
                
                return scholarId
            }else {
                return nil
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "scholarId")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func login(email: String, password: String, completionHandler: ((error: NSError?) -> Void)? = nil) {
        if let encodedPassword = password.dataUsingEncoding(NSUTF8StringEncoding)?.sha256()?.toHexString() {
        
        request(.POST, "\(self.serverUrl)/api/login/\(self.apiKey)", parameters: ["email": email, "password": encodedPassword])
            .responseString() { response in
                print (response.result.error)
                
                if let error = response.result.error {
                    completionHandler?(error: error)
                    return
                }
                
                if let data = response.result.value {
                    let json = JSON.parse(data)
                        print("JSON: \(json)")
                    
                    if let errorCode = json["errorCode"].int, let message = json["message"].string {
                        print ("Error logging in with code: \(errorCode) and message \(message)")
                        completionHandler?(error: NSError(domain: "com.wwdcscholars.loginError", code: errorCode, userInfo: ["message": message]))
                        return
                    }
                    
                    if let scholarId = json["id"].string, let firstName = json["firstName"].string {
                        self.scholarId = scholarId
                        print ("Logged in! Welcome \(firstName)")
                        completionHandler?(error: nil)
                    }
                }
        }
            
        }
    }
    
}