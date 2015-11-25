//
//  TopCategoryView.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-23.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class TopCategoryView: UIView {
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var storesPerCategoryButton: UIButton!
    var category: STCategory?

    override func awakeFromNib() {
        self.categoryLabel.text = ""
        self.categoryImageView.image = nil
    }
    
    func display(category: STCategory)->Void{
        self.categoryLabel.text = category.category_name
        ImageCacheManager.loadImageViewForUrl(category.og_img, placeHolderImage: nil, imageView: self.categoryImageView)
    }
}