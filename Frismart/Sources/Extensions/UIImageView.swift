//
//  UIImageView.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-18.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

extension UIImageView {
    func withRoundCorners(radius: CGFloat){
        self.layer.borderWidth = kProfileMenuBorderwidth
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor().frismartDefaultBackgroundColor.CGColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
