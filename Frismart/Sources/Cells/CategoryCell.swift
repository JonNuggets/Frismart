//
//  CategoryCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-10.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class CategoryCell : UITableViewCell {

    @IBOutlet var cellBackgroundImageView: UIImageView!
    @IBOutlet var opacityFilterView: UIView!
    @IBOutlet var categoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.categoryLabel.backgroundColor = UIColor().frismartTableViewBackgroundColor
        self.cellBackgroundImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellBackgroundImageView.image = nil
        self.categoryLabel.text = ""
    }
    
    //  TODO: Afficher les données de la catégorie
    func display(category: STCategory) -> Void{
        self.categoryLabel.text = category.category_name
        self.categoryLabel.sizeToFit()
        
        ImageCacheManager.loadImageViewForUrl(category.og_img, placeHolderImage: "loadPlaceholderImage", imageView: self.cellBackgroundImageView)
    }
}