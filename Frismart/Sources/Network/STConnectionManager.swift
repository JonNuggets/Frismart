//
//  STConnectionManage.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-26.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

// Frismart API
let kBASE_URL                           = "http://www.frismart.com/app/webroot/storefind/"
let kLOGIN_URL                          = "rest/login.php"
let kCATEGORY_JSON_URL                  = "rest/categories.php"
let kDATA_JSON_URL                      = "rest/data.php"
let kDATA_NEWS_URL                      = "rest/data_news.php"
let kREGISTER_URL                       = "rest/register.php"
let kGET_USER_RATING_URL                = "rest/get_rating_user.php"
let kPOST_RATING_URL                    = "rest/post_rating.php"
let kWEATHER_URL                        = "http://api.openweathermap.org/data/2.5/weather?q=%@,%@&appid=%@"
let kOPEN_WEATHER_MAP_APPID             = "9a9acabf3ab23a9c69117a55c819667a"
let kUserCredentialsSetting             = "username=%@&password=%@"
let kUserRating                         = "store_id=%@&user_id=%@&login_hash=%@&rating=%@"

class STConnectionManager : NSObject {

    var session: NSURLSession?
    
    class var sharedInstance : STConnectionManager {
        struct Static {
            static let instance : STConnectionManager = STConnectionManager()
        }
        return Static.instance
    }

    class func login(username: String, password: String, onSuccessHandler: (()->())? = nil, onFailureHandler: (NSError -> ())? = nil)-> Void {
        let loginURL: String = kBASE_URL+kLOGIN_URL
        
        let request = NSMutableURLRequest(URL: NSURL(string: loginURL)!)
        request.HTTPMethod = "POST"
        
        let bodyString : String = String(format: kUserCredentialsSetting, username, password)
        let data : NSData = (bodyString).dataUsingEncoding(NSUTF8StringEncoding)!;
        
        request.HTTPBody = data;
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request){data, response, error -> Void in
            if error != nil {
            }
            else{
                if data != nil {
                    let loginResponse : JSON? = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    AppData.sharedInstance.user = STUser(dictionary: (loginResponse?["user_info"])!.dictionaryObject)
                    
                    print("login_hash : \(AppData.sharedInstance.user?.login_hash)")
                    
                    if AppData.sharedInstance.user?.login_hash != nil {
                        if onSuccessHandler != nil {
                            onSuccessHandler?()
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getData(onSuccessHandler: ((JSON)->())? = nil, onFailureHandler: (NSError -> ())? = nil)-> Void {
        let storesDataURL: String = kBASE_URL+kDATA_JSON_URL
        
        let request = NSMutableURLRequest(URL: NSURL(string: storesDataURL)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error != nil {
                if onFailureHandler != nil {
                    onFailureHandler?(error!)
                }
            }
            else{
                if data != nil {
                    var parseError = NSError?()
                    let dataJSON : JSON = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: &parseError)

                    if dataJSON != nil {
                        if onSuccessHandler != nil {
                           onSuccessHandler?(dataJSON)
                        }
                    }
                    else {
                        if onFailureHandler != nil {
                            onFailureHandler?(parseError!)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    class func getCategories(onSuccessHandler: ((JSON)->())? = nil, onFailureHandler: (NSError -> ())? = nil)-> Void {
        let storesDataURL: String = kBASE_URL+kCATEGORY_JSON_URL
        
        let request = NSMutableURLRequest(URL: NSURL(string: storesDataURL)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error != nil {
                if onFailureHandler != nil {
                    onFailureHandler?(error!)
                }
            }
            else{
                if data != nil {
                    var parseError = NSError?()
                    let dataJSON : JSON = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                    
                    if dataJSON != nil {
                        if onSuccessHandler != nil {
                            onSuccessHandler?(dataJSON)
                        }
                    }
                    else {
                        if onFailureHandler != nil {
                            onFailureHandler?(parseError!)
                        }
                    }
                }
            }
        })
        task.resume()
    }

    class func getWeather(placemark: CLPlacemark, onSuccessHandler: ((JSON)->())? = nil, onFailureHandler: (NSError -> ())? = nil)-> Void {

        let weatherURL: String = String(format: kWEATHER_URL, (placemark.locality)!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!, placemark.ISOcountryCode!, kOPEN_WEATHER_MAP_APPID)
            
        let request = NSMutableURLRequest(URL: NSURL(string: weatherURL)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error != nil {
                if onFailureHandler != nil {
                    onFailureHandler?(error!)
                }
            }
            else{
                if data != nil {
                    var parseError = NSError?()
                    let dataJSON : JSON = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                    
                    if dataJSON != nil {
                        if onSuccessHandler != nil {
                            onSuccessHandler?(dataJSON)
                        }
                    }
                    else {
                        if onFailureHandler != nil {
                            onFailureHandler?(parseError!)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    class func postRating(rating: String, store: STStore,onSuccessHandler: (()->())? = nil, onFailureHandler: (NSError -> ())? = nil)-> Void {
        let getUserRatingURL: String = kBASE_URL+kPOST_RATING_URL
        
        let request = NSMutableURLRequest(URL: NSURL(string: getUserRatingURL)!)
        request.HTTPMethod = "POST"
        
        let bodyString : String = String(format: kUserRating, store.store_id!, (AppData.sharedInstance.user?.user_id)!, (AppData.sharedInstance.user?.login_hash)!, rating)
        
        print("bodyString \(bodyString)")
        
        let data : NSData = (bodyString).dataUsingEncoding(NSUTF8StringEncoding)!;
        
        request.HTTPBody = data;
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error != nil {
                if onFailureHandler != nil {
                    onFailureHandler?(error!)
                }
            }
            else{
                if data != nil {
                    var parseError = NSError?()
                    let dataJSON : JSON = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
                    
                    if dataJSON != nil {
                        if onSuccessHandler != nil {
                            onSuccessHandler?()
                        }
                    }
                    else {
                        if onFailureHandler != nil {
                            onFailureHandler?(parseError!)
                        }
                    }
                }
            }
        })
        task.resume()
    }
}