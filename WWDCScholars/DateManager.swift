//
//  DateManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

extension NSDate {
    static func dateMinusYears(years: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        let options: NSCalendarOptions = .WrapComponents
        dateComponents.year = -years
        
        let endDate = calendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: options)
        return endDate!
    }
}

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
