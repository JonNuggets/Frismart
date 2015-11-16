//
//  NSDate.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-12.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

extension NSDate {
    func getCurrentDayTimeStringFormat()->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE-HH:mm"
        let date = NSDate()
        return dateFormatter.stringFromDate(date)
    }
}