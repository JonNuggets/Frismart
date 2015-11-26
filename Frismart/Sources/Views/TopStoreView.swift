//
//  TopStoreView.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-23.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class TopStoreView: UIView {
    @IBOutlet var storeImageView: UIImageView!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeRateLabel: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var storeDetailsButton: UIButton!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    var store: STStore?
    
    override func awakeFromNib() {
        self.storeImageView.image = nil
        self.favoriteImageView.image = nil
        self.storeNameLabel.text = ""
        self.storeRateLabel.text = ""
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor().frismartDefaultBorderColor.CGColor
        self.floatRatingView.editable = false
        self.floatRatingView.floatRatings = true
    }
    
    func display(store: STStore)->Void{
        self.storeNameLabel.text = store.store_name
        
        if store.rating_count == "0" {
            self.storeRateLabel.text = "0.0"
            self.floatRatingView.rating = 0
        }
        else {
            let ratingValue : Float = Float( Float(store.rating_total!)! / Float(store.rating_count!)! )
            self.floatRatingView.rating = ratingValue
            self.storeRateLabel.text = String(ratingValue)
        }
        
        self.storeAddressLabel.text = store.store_address
        
        let photoArray = store.getPhotos()
        if photoArray.count > 0 {
            ImageCacheManager.loadImageViewForUrl(photoArray[0].photo_url, placeHolderImage: nil, imageView: self.storeImageView)
        }
        
        self.favoriteImageView?.image = UIImage(named: "StoreDetails_Like_Unchecked")!.imageWithColor(UIColor.redColor())
    }
}