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
    
    func login(email: String, password: String) {
        if let encodedPassword = password.dataUsingEncoding(NSUTF8StringEncoding)?.sha256()?.toHexString() {
        
        request(.POST, "\(self.serverUrl)/api/login/\(self.apiKey)", parameters: ["email": email, "password": encodedPassword])
            .responseString() { response in
                print (response.result.error)
                if let data = response.result.value {
                    let json = JSON.parse(data)
                        print("JSON: \(json)")
//                    if let array = json.array {
//                        completionHandler()
//                    }
                }
        }
            
        }
    }
    
}