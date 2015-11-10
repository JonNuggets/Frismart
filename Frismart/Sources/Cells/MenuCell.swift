//
//  MenuCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class MenuCell : UITableViewCell {
    @IBOutlet var menuIconImageView: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.menuLabel.textColor = UIColor().frismartTableViewBackgroundColor
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.menuIconImageView.image = nil
        self.menuLabel.text = ""
    }
}
