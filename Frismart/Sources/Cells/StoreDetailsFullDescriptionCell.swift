//
//  StoreDetailsFullDescriptionCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-21.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class StoreDetailsFullDescriptionCell : UITableViewCell {
    @IBOutlet var storeDescLabel: UILabel!
    
    func display(store: STStore){
        self.storeDescLabel.text = store.store_desc
        self.storeDescLabel.sizeToFit()
    }
    
    func getLabelHeight() -> CGFloat{
        return self.storeDescLabel.bounds.height
    }
}