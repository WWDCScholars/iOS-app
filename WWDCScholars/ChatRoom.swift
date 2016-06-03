//
//  ChatRoom.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 03/06/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

struct ChatRoom {
    let name: String
    let identifier: String
    
    static func getChatItems() -> [ChatRoom] {
        let chatItems: [ChatRoom] = []
        
        let general = ChatRoom(name: "General", identifier: "general")
        let random = ChatRoom(name: "Random", identifier: "random")
        let meetups = ChatRoom(name: "Meetups", identifier: "meetups")
        let events = ChatRoom(name: "Events", identifier: "events")
        
        return [general, random, meetups, events]
    }
}