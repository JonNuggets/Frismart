//
//  ImageCacheManager.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-23.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import UIKit
import Foundation

class ImageCacheManager
{
    static var cache = NSCache()
    
    class func loadImageViewForUrl(urlString: String?, placeHolderImage: String!, imageView: UIImageView, completionHandler:((url: String) -> ())? = nil) -> NSURLSessionDataTask? {
        // set placeholder image by default
        if placeHolderImage != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                imageView.image = UIImage(named: placeHolderImage)
                //imageView.contentMode = .ScaleAspectFill
            })
        }
        
        if urlString == nil || urlString!.length == 0 {
            if completionHandler != nil {
                completionHandler!(url: "")
            }
            
            return nil;
        }
        
        // Get image date from cache if available
        let data: NSData? = self.cache.objectForKey(urlString!) as? NSData
        if data != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
                let image = UIImage(data: data!)
                if image != nil {
                    dispatch_async(dispatch_get_main_queue(), {() in
                        UIView.transitionWithView(imageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            imageView.image = image
                            //imageView.contentMode = .ScaleAspectFill
                            }, completion: { (fininshed: Bool) -> () in
                                if completionHandler != nil {
                                    completionHandler!(url: urlString!)
                                }
                        })
                    })
                }
                else {
                    if completionHandler != nil {
                        completionHandler!(url: urlString!)
                    }
                }
            })
        }
        else {
            // If image data is not available in cache...fetch it (image data) and then store it in the cache for next time
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            
            let downloadTask : NSURLSessionDataTask = session.dataTaskWithURL(NSURL(string: urlString!)!, completionHandler: {(data, response, error) in
                if data != nil {
                    self.cache.setObject(data!, forKey: urlString!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        UIView.transitionWithView(imageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            imageView.image = UIImage(data: data!)
                            //imageView.contentMode = .ScaleAspectFill
                            }, completion: { (fininshed: Bool) -> () in
                                if completionHandler != nil {
                                    completionHandler!(url: urlString!)
                                }
                        })
                    })
                }
                else {
                    // Make sure the completion callback is called even when there was an request error
                    // Set returned urlString to nil in such case.
                    if completionHandler != nil {
                        completionHandler!(url: "")
                    }
                }
            });
            
            downloadTask.resume()
            return downloadTask
        }
        
        return nil
    }
}
