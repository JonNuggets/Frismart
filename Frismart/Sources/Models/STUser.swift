//
//  STUser.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-15.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import CoreLocation

class STUser : STBaseModel{
    var facebook_id : String?
    var photo_url   : String?
    var login_hash  : String?
    var username    : String?
    var user_id     : String?
    var full_name   : String?
    var twitter_id  : String?
    var thumb_url   : String?
    var email       : String?
    var currentPlacemark: CLPlacemark?
    var currentLocation: CLLocation?
    var profileImageView : UIImageView?
}
