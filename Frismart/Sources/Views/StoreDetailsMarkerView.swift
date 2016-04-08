//
//  StoreDetailsMarkerView.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-26.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class StoreDetailsMarkerView: UIView {
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeCategoryLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    var thisStore: STStore?

    override func awakeFromNib() {
        self.storeNameLabel.text = ""
        self.storeCategoryLabel.text = ""
        self.floatRatingView.editable = false
        self.floatRatingView.floatRatings = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor().frismartDefaultBackgroundColor.CGColor
    }
    
    func display(store: STStore)->Void{
        self.storeNameLabel.text = store.store_name
        self.storeCategoryLabel.text = store.getCategory()
        
        
        if store.rating_count == "0" {
            self.floatRatingView.rating = 0
        }
        else {
            let ratingValue : Float = Float(Float(store.rating_total)! / Float(store.rating_count)!)
            self.floatRatingView.rating = ratingValue
        }
    }
}