//
//  NSDate.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-12.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

extension NSDate {
    func getCurrentDateWithFormat(format: String)->NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let currentDate = NSDate()

        return dateFormatter.dateFromString(dateFormatter.stringFromDate(currentDate))!
    }
    
    func compareHours(date: NSDate)-> NSComparisonResult {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let selfToCompare = dateFormatter.dateFromString(dateFormatter.stringFromDate(self))
        let dateToCompare = dateFormatter.dateFromString(dateFormatter.stringFromDate(date))
        
        return (selfToCompare?.compare(dateToCompare!))!
    }
    
    func stringToDate(dateString: String)->NSDate{
        let dateFormatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "fr_FR")

        dateFormatter.locale = locale
        dateFormatter.dateFormat = "EEE HH:mm"
        return dateFormatter.dateFromString(dateString)!
    }
}