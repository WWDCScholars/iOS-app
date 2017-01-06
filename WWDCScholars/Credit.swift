//
//  Credit.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 09/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

struct Credit {
    let name: String
    let location: String
    let tasks: [String]
    let image: UIImage
    let id: String?
    
    static func getCredit(_ name: String, location: String, tasks: [String], image: String, id: String) -> Credit {
        return Credit(name: name, location: location, tasks: tasks, image: UIImage(named: name)!, id: id)
    }
}
