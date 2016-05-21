//
//  DateManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

class DateManager {
    static private let sharedInstance = DateManager()
    
    private lazy var shortDateFormatter: NSDateFormatter = {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        return dateFormatter
    }()
    
    static func shortDateStringFromDate(date: NSDate) -> String {
        return self.sharedInstance.shortDateFormatter.stringFromDate(date)
    }
}
