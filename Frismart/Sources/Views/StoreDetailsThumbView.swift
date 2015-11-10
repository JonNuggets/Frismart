//
//  StoreDetailsThumbView.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-16.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class StoreDetailsThumbView: UIView {
    @IBOutlet var thumbnailImageView : UIImageView!
    @IBOutlet var thumbnailButton : UIButton!
    
    override func awakeFromNib() {
        self.thumbnailImageView.image = nil
    }
    
    func display(photo: STPhoto)->Void{
        ImageCacheManager.loadImageViewForUrl(photo.thumb_url, placeHolderImage: nil, imageView: self.thumbnailImageView)
    }
}