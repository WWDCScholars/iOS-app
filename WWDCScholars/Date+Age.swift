//
//  Date+Age.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 03/06/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

extension Date {
    var age: Int {
        let calendar = NSCalendar.current
    
        let now = calendar.startOfDay(for: Date())
        let birthdate = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.year], from: birthdate, to: now)
        return components.year!
    }
}
