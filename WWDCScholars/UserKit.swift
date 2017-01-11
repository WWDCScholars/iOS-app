//
//  UserKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 28/05/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire
import SwiftyJSON

class UserKit: ApiBase {
    static let sharedInstance = UserKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    fileprivate override init() {
    }
    
    var isLoggedIn: Bool {
        return scholarId != "" && scholarId != nil
    }
    
    var scholarId: String? {
        get {
            if let scholarId = Foundation.UserDefaults.standard.string(forKey: "scholarId") {
                if scholarId == "" {
                    return nil
                }
                
                return scholarId
            }else {
                return nil
            }
        }
        set {
            Foundation.UserDefaults.standard.set(newValue, forKey: "scholarId")
            Foundation.UserDefaults.standard.synchronize()
        }
    }
    
    var loggedInScholar: Scholar? {
        if let scholarId = scholarId {
            return DatabaseManager.sharedInstance.scholarForId(scholarId)
        }
        
        return nil
    }
    
    func login(_ email: String, password: String, completionHandler: ((_ error: NSError?) -> Void)? = nil) {
        if let encodedPassword = password.data(using: String.Encoding.utf8)?.sha256().toHexString() {
            
            
            
           request("\(self.serverUrl)/api/login/\(self.apiKey)", method: .post, parameters: ["email": email as AnyObject, "password": encodedPassword as AnyObject])
                .responseString() { response in
                    print (response.result.error!)
                    
                    if let error = response.result.error {
                        completionHandler?(error as NSError?)
                        return
                    }
                    
                    if let data = response.result.value {
                        let json = JSON.parse(data)
                        print("JSON: \(json)")
                        
                        if let errorCode = json["errorCode"].int, let message = json["message"].string {
                            print ("Error logging in with code: \(errorCode) and message \(message)")
                            completionHandler?(NSError(domain: "com.wwdcscholars.loginError", code: errorCode, userInfo: ["message": message]))
                            return
                        }
                        
                        if let scholarId = json["id"].string, let firstName = json["firstName"].string {
                            self.scholarId = scholarId
                            print ("Logged in! Welcome \(firstName)")
                            completionHandler?(nil)
                        }
                    }
            }
        }
    }
    
    func logout(){
        self.scholarId = nil
    }
    
}
