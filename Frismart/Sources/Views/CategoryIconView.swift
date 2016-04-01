//
//  CategoryIconView.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-30.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class CategoryIconView: UIView {
    @IBOutlet var categoryIconBackgroundView: UIView!
    @IBOutlet var categoryIconImageView: UIImageView!
    @IBOutlet var categoryIconButton: UIButton!
    
    override func awakeFromNib() {
        self.categoryIconImageView.image = nil
        
        self.categoryIconBackgroundView.layer.borderWidth = kProfileMenuBorderwidth
        self.categoryIconBackgroundView.layer.masksToBounds = false
        self.categoryIconBackgroundView.layer.borderColor = UIColor.whiteColor().CGColor
        self.categoryIconBackgroundView.layer.cornerRadius = 3.0
    }
    
    func display(category: STCategory) {
        let categoryIcon = String(format: "Category_%@Icon", category.category_name)
        
        self.categoryIconBackgroundView.backgroundColor = UIColor.clearColor()
        self.categoryIconImageView.image = UIImage(named: categoryIcon.removePunctuation())?.imageWithColor(UIColor.whiteColor())
    }
    
    func switchColor(category: STCategory) {
        let categoryIcon = String(format: "Category_%@Icon", category.category_name)
        
        if self.categoryIconButton.selected == true {
            self.categoryIconButton.selected = false
            self.categoryIconBackgroundView.backgroundColor = UIColor.clearColor()
            self.categoryIconImageView.image = UIImage(named: categoryIcon.removePunctuation())?.imageWithColor(UIColor.whiteColor())
        }
        else {
            self.categoryIconButton.selected = true
            self.categoryIconBackgroundView.backgroundColor = UIColor.whiteColor()
            self.categoryIconImageView.image = UIImage(named: categoryIcon.removePunctuation())?.imageWithColor(UIColor().frismartDefaultBackgroundColor)
        }
    }
}