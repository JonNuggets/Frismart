//
//  NSDate.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-12.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

extension NSDate {
    func compareHours(date: NSDate)-> NSComparisonResult {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        dateFormatter.dateFormat = "HH:mm"
        
        let selfToCompareString = dateFormatter.stringFromDate(self)
        let dateToCompareString = dateFormatter.stringFromDate(date)
        
        let selfToCompareTime = selfToCompareString.componentsSeparatedByString(":")
        let dateToCompareTime = dateToCompareString.componentsSeparatedByString(":")
        
        let selfToCompareHour = Int(selfToCompareTime[0])
        let selfToCompareMinute = Int(selfToCompareTime[1])
        
        let dateToCompareHour = Int(dateToCompareTime[0])
        let dateToCompareMinute = Int(dateToCompareTime[1])
        
        if selfToCompareHour > dateToCompareHour {
            return .OrderedDescending
        }
        else {
            if selfToCompareHour < dateToCompareHour {
                return .OrderedAscending
            }
            else {
                if selfToCompareMinute < dateToCompareMinute {
                    return .OrderedAscending
                }
                else {
                    if selfToCompareMinute > dateToCompareMinute {
                        return .OrderedDescending
                    }
                    else {
                        return .OrderedSame
                    }
                }
            }
        }
    }
    
    func stringToDate(dateString: String)->NSDate{
        let dateFormatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "fr_FR")

        dateFormatter.locale = locale
        dateFormatter.dateFormat = "EEE HH:mm"
 
        return dateFormatter.dateFromString(dateString)!
    }
    

    private func toLocalTime()-> NSDate{
        let timeZone = NSTimeZone.localTimeZone()
        let seconds = timeZone.secondsFromGMT
        
        return self.dateByAddingTimeInterval(Double(seconds))
    }

}