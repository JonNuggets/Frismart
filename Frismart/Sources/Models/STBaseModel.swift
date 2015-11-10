//
//  STBaseModel.swift
//  Created by jlaurenstin on 2015-04-16.
//  All rights reserved.
//

import Foundation
import SwiftyJSON

public class STBaseModel: NSObject {
    override init () {
        super.init()
    }
    
    init (nsdictionary : NSDictionary!) {
        super.init()
        if nsdictionary != nil {
            for (key, value) in nsdictionary {
                // If property exists
                if (self.respondsToSelector(NSSelectorFromString(key as! String))) {
                    self.setValue(value, forKey: key as! String)
                }
            }
        }
    }
    
    init (dictionary : Dictionary<String, AnyObject>!) {
        super.init()
        if dictionary != nil {
            for (key, value) in dictionary {
                // If property exists
                if (self.respondsToSelector(NSSelectorFromString(key as String))) {
                    self.setValue(value, forKey: key as String)
                }
            }
        }
    }
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        let properties = self.propertyNames();
        
        for property in properties {
            let value: AnyObject? = self.valueForKey(property)
            if value != nil {
                json[property] = JSON(value!)
            }
        }
        
        return json
    }
}
