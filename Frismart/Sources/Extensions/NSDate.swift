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
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Hour, .Minute], fromDate: date)
        let day = String(components.day)
        let hour = String(components.hour)
        let minutes = String(components.minute)
        return day + "/" + hour + ":" + minutes
    }
}