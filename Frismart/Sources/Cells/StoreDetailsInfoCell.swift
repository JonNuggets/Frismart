//
//  StoreDetailsInfoCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-30.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class StoreDetailsInfoCell : UITableViewCell {
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeRateLabel: UILabel!
    @IBOutlet var storeHoursImageView: UIImageView!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.floatRatingView.editable = false
        self.floatRatingView.floatRatings = true
        self.storeHoursImageView.image = nil
    }
    
    func display(store: STStore) -> Void{
        self.storeNameLabel.text = store.store_name
        self.storeNameLabel.sizeToFit()
        
        if store.rating_count == "0" {
            self.storeRateLabel.text = "0"
            self.floatRatingView.rating = 0
        }
        else {
            let ratingValue : Float = Float( Float(store.rating_total!)! / Float(store.rating_count!)! )
            self.storeRateLabel.text = String(ratingValue)
            self.floatRatingView.rating = ratingValue
        }
        
        self.storeRateLabel.sizeToFit()
        self.storeAddressLabel.text = store.store_address
    
        var isOpen = false
        let storeHours = store.horaire?.parseHours()
        let currentDate = NSDate()
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let currentDayComponent: NSDateComponents = calendar.components(.Weekday, fromDate: currentDate)
        let currentWeekDay = (currentDayComponent.weekday <= 7 && currentDayComponent.weekday != 0) ? currentDayComponent.weekday - 1 : 1

        for days in (storeHours?.keys)! {
            let daysList = days.componentsSeparatedByString("-")

            if daysList.count > 1 {
                for day in daysList {
                    let dateStartString : String = String(format: "%@ %@", day, storeHours![days]![0]["start"]!)
                    let dateEndString : String = String(format: "%@ %@", day, storeHours![days]![0]["end"]!)
                    
                    let dateStart = NSDate().stringToDate(dateStartString)
                    let dateEnd = NSDate().stringToDate(dateEndString)
                    
                    let startDay = STHelpers.getWeekDay(daysList[0])
                    let endDay = STHelpers.getWeekDay(daysList[1])
                    
                    if dateEnd.compare(dateStart) == .OrderedDescending {
                        
                        if (startDay <= currentWeekDay &&  currentWeekDay <= endDay){
                            
                            if (dateEnd.compareHours(currentDate) == .OrderedDescending)
                                && (dateStart.compareHours(currentDate) == .OrderedAscending){
                                    isOpen = true
                                    break
                            }
                        }
                    }
                    else {
                        if (startDay <= currentWeekDay &&  currentWeekDay <= (endDay + 1)){
                            
                            if (dateEnd.compareHours(currentDate) == .OrderedAscending)
                                && (dateStart.compareHours(currentDate) == .OrderedAscending){
                                    isOpen = true
                                    break
                            }
                        }
                    }
                }
            }
        }
        
        if isOpen {
            self.storeHoursImageView?.image = UIImage(named: "StoreDetails_Clock")!.imageWithColor(UIColor.greenColor())
        }
        else {
            self.storeHoursImageView?.image = UIImage(named: "StoreDetails_Clock")!.imageWithColor(UIColor.redColor())
        }
    }
}
