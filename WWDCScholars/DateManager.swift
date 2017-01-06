//
//  DateManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

extension Date {
    static func dateMinusYears(_ years: Int) -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        var dateComponents = DateComponents()
        let options: NSCalendar.Options = .wrapComponents
        dateComponents.year = -years
        
        let endDate = (calendar as NSCalendar).date(byAdding: dateComponents, to: currentDate, options: options)
        return endDate!
    }
}

class DateManager {
    static fileprivate let sharedInstance = DateManager()
    
    fileprivate lazy var shortDateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    static func shortDateStringFromDate(_ date: Date) -> String {
        return self.sharedInstance.shortDateFormatter.string(from: date)
    }
}
