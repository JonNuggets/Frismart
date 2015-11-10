//
//  StoreDetailsContactsCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-16.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class StoreDetailsContactsCell : UITableViewCell {
    @IBOutlet var storeAppelButton: UIButton!
    @IBOutlet var storeEmailButton: UIButton!
    @IBOutlet var storeWebsiteButton: UIButton!
    @IBOutlet var storeItineraryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.storeAppelButton.setImage(UIImage(named: "StoreDetails_Phone")!.imageWithColor(UIColor().frismartDefaultBackgroundColor), forState: .Normal)
        self.storeAppelButton.setImage(UIImage(named: "StoreDetails_Phone")!.imageWithColor(UIColor().frismartDisabledBackgroundColor), forState: .Disabled)
        
        
        self.storeEmailButton.setImage(UIImage(named: "StoreDetails_Email")!.imageWithColor(UIColor().frismartDefaultBackgroundColor), forState: .Normal)
        self.storeEmailButton.setImage(UIImage(named: "StoreDetails_Email")!.imageWithColor(UIColor().frismartDisabledBackgroundColor), forState: .Disabled)
        
        
        self.storeWebsiteButton.setImage(UIImage(named: "StoreDetails_Website")!.imageWithColor(UIColor().frismartDefaultBackgroundColor), forState: .Normal)
        self.storeWebsiteButton.setImage(UIImage(named: "StoreDetails_Website")!.imageWithColor(UIColor().frismartDisabledBackgroundColor), forState: .Disabled)
        
        self.storeItineraryButton.setImage(UIImage(named: "StoreDetails_Route")!.imageWithColor(UIColor().frismartDefaultBackgroundColor), forState: .Normal)
        self.storeItineraryButton.setImage(UIImage(named: "StoreDetails_Route")!.imageWithColor(UIColor().frismartDisabledBackgroundColor), forState: .Disabled)
    }
}