//
//  STActivityIndicatorView.swift
//  Frismart
//  Created by jlaurenstin on 2015-02-18.
//

import Foundation
import UIKit

// Acitvity Indicator
let kACTIVITY_INDICATOR_SMALL_SIZE : CGFloat                            = 35.0
let kACTIVITY_INDICATOR_Y_OFFSET : CGFloat                              = 10.0

let kACTIVITY_INDICATOR_DELAY_FRAME_COUNT                               = 1
let kACTIVITY_INDICATOR_ANIMATION_DURATION : NSTimeInterval             = 0.8

let kACTIVITY_INDICATOR_BLUR_EFFECT_ALPHA                               = CGFloat(0.85)
let kACTIVITY_INDICATOR_DEFAULT_ALPHA_VALUE                             = CGFloat(0.0)

let kACTIVITY_INDICATOR_ANIMATION_FRAMES_COUNT                          = 25

let kACTIVITY_CUSTOM_INDICATOR_ANIMATION_DURATION : NSTimeInterval      = 1.2
let kACTIVITY_INDICATOR_ANIMATION_FADE_IN_DURATION : NSTimeInterval     = 0.25
let kACTIVITY_INDICATOR_ANIMATION_FADE_OUT_DURATION : NSTimeInterval    = 0.2

class STActivityIndicatorView: UIView {
    @IBOutlet weak var activityIndicatorImageView: UIImageView!
    
    var viewFromNib: UIView?
    
    // MARK: Init methods
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        loadSubviews()
    }
    
    convenience init () {
        self.init(frame:CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Life cycle
    func loadSubviews () {
        self.viewFromNib = NSBundle.mainBundle().loadNibNamed("STActivityIndicatorView", owner: self, options: nil)[0] as? UIView
        self.viewFromNib!.frame = self.bounds
        self.addSubview(self.viewFromNib!)
        
        self.activityIndicatorImageView = viewFromNib?.subviews[0] as! UIImageView
        
        self.alpha = kACTIVITY_INDICATOR_DEFAULT_ALPHA_VALUE
        
        // Add delay animation frames (first frame x number of times to create the delay effect)
        var imgListArray : [AnyObject] = Array()
        for _ in 1...kACTIVITY_INDICATOR_DELAY_FRAME_COUNT {
            imgListArray.append(UIImage(named: "ActivityIndicator_1")!)
        }
        
        // Add animation frames
        for countValue in 1...kACTIVITY_INDICATOR_ANIMATION_FRAMES_COUNT {
            let image  = UIImage(named: "ActivityIndicator_\(countValue)")
            imgListArray.append(image!)
        }
        
        self.activityIndicatorImageView!.animationImages = imgListArray as? [UIImage]
        self.activityIndicatorImageView!.animationDuration = kACTIVITY_CUSTOM_INDICATOR_ANIMATION_DURATION
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.frame
        blurEffectView.alpha = kACTIVITY_INDICATOR_BLUR_EFFECT_ALPHA
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.frame
        
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        self.userInteractionEnabled = false
    }
    
    // MARK: Animation methods
    
    func startAnimation () -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.fadeIn (kACTIVITY_INDICATOR_ANIMATION_FADE_IN_DURATION, delay:0.0, completion: {(finished: Bool) -> Void in
                self.activityIndicatorImageView!.startAnimating()
            })
        })
    }
    
    func stopAnimating() -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.fadeOut (kACTIVITY_INDICATOR_ANIMATION_FADE_OUT_DURATION, delay:0.0, completion: {(finished: Bool) -> Void in
                self.activityIndicatorImageView!.stopAnimating()
            })
        })
    }
    
    func isAnimating() -> Bool {
        return self.activityIndicatorImageView!.isAnimating()
    }
}
