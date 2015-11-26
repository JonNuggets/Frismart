//
//  STPlaceMarker.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-26.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class STPlaceMarker: GMSMarker {
    let store: STStore
    
    init(store: STStore) {
        self.store = store
        super.init()
        self.icon = UIImage(named: String(format: "Category_%@Pin", store.getCategory().removePunctuation()))?.imageWithColor(UIColor().frismartDefaultBackgroundColor)
    }
}
