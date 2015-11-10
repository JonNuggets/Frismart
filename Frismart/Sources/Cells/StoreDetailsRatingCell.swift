//
//  StoreDetailsRatingCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-20.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class StoreDetailsRatingCell : UITableViewCell {
    @IBOutlet var storeRatingView: FloatRatingView!
    @IBOutlet var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.sectionLabel.text = NSLocalizedString("StoreDetailsScreen_RatingSectionTitle", comment:"")
    }
}