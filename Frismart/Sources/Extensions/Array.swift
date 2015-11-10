//
//  Array.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-28.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

extension Array where Element: Equatable{
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}