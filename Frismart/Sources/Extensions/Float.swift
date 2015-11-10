//
//  Float.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-16.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

extension Float {
    static func fromKelvinToCelsius (tempInKelvin: Float) -> Int{ return Int(tempInKelvin - 273.15) }
}