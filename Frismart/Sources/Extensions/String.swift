//
//  String.swift
//  mFind
//
//  Created by jlaurenstin on 2015-03-25.
//

import Foundation

extension String {
    var length : Int { return self.utf16.count }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func validateURL() -> Bool {
        // Allow empty url string to be considered as valid urls for now (because of KC implementation)
        if self.length == 0 {
            return true
        }
        
        let urlRegex: NSString = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return urlTest.evaluateWithObject(self)
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func forceSecureHTTPSURL() -> String {
        let urlStringHTTPS = self.replace("http:", withString: "https:")
        return urlStringHTTPS
    }
    
    func removePunctuation() -> String{
        
        return self.stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    func parseHours()-> Dictionary<String, [Dictionary<String, String>]>{
    
        let daysHoursRanges = self.componentsSeparatedByString(";")
        var daysDictionary: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
        
        for daysHoursRange in daysHoursRanges {
            
            if !daysHoursRange.isEmpty {
                let daysHours = daysHoursRange.componentsSeparatedByString(" ")
                let daysRange = daysHours[0]
                let hoursRange = daysHours[1].componentsSeparatedByString(",")
            
                var hoursList: [Dictionary<String, String>] = [Dictionary<String, String>]()
                for hours in hoursRange {
                    let hour = hours.componentsSeparatedByString("-")
                    if hour.count == 2 {
                        let hoursStartEnd: Dictionary<String, String> = ["start":hour[0], "end":hour[1]]
                        hoursList.append(hoursStartEnd)
                    }
                }
                daysDictionary[daysRange] = hoursList
            }
        }
        return daysDictionary
    }
}
