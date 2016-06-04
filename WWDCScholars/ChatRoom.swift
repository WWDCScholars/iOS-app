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
    let shortDescription: String
    let identifier: String
    
    static func getChatItems() -> [ChatRoom] {        
        let general = ChatRoom(name: "General", shortDescription: "Discuss anything WWDC related", identifier: "general")
        let random = ChatRoom(name: "Random", shortDescription: "Things that are just too random to go anywhere else!", identifier: "random")
        let meetups = ChatRoom(name: "Meetups", shortDescription: "Discuss meetup locations and times", identifier: "meetups")
        let events = ChatRoom(name: "Events", shortDescription: "Arrange group activities and events", identifier: "events")
        let projects = ChatRoom(name: "Projects", shortDescription: "Form teams, or showcase your upcoming projects!", identifier: "projects")
        
        return [general, random, meetups, events, projects]
    }
}