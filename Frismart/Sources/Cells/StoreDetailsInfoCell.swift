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
    
        let storeHours = store.horaire?.parseHours()
        
        print("\(store.store_name) - \(store.store_id) - \(storeHours)")
        
        
        for days in (storeHours?.keys)! {
            let daysList = days.componentsSeparatedByString("-")
            
            print(daysList)
            
            let currentDayTime: String = NSDate().getCurrentDayTimeStringFormat()
            let currentDayTimeArray: [String] = currentDayTime.componentsSeparatedByString("-")
            let currentDay: String = currentDayTimeArray[0].stringByReplacingOccurrencesOfString(".", withString: "")
            let currentTime: [String] = currentDayTimeArray[1].componentsSeparatedByString(":")
            let currentHour: Int = Int(currentTime[0])!
            let currentMinutes: Int = Int(currentTime[1])!
            
            print("Day: \(currentDay)")
            print("Hours: \(currentHour)")
            print("Minutes: \(currentMinutes)")
            
            if daysList.count > 1 {
                print("YES")
            }
            else {
                print("NO")
            }
        }
        
        self.storeHoursImageView?.image = UIImage(named: "StoreDetails_Clock")!.imageWithColor(UIColor.greenColor())
    }
}
