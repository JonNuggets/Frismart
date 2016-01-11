//
//  UILabel.swift
//  Frismart
//
//  Created by James Laurenstin on 29-10-14.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import UIKit

extension UILabel {
    func optimalHeight() -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width/UIScreen.mainScreen().scale, CGFloat.max))

        label.numberOfLines = 20
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textAlignment = self.textAlignment
        label.font = self.font
        label.text = self.text

        label.sizeToFit()
        
        return label.frame.height + 34.0
    }
}