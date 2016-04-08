//
//  ModalAdsViewController.swift
//  Frismart
//
//  Created by James Laurenstin on 2016-04-08.
//  Copyright © 2016 Karl Mounguengui. All rights reserved.
//

import Foundation


class ModalAdsViewController: STBaseViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var adImageView: UIImageView!

    var autoHideTimer: NSTimer!

    // MARK: - Life cycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        AppData.sharedInstance.customAdOnDisplay = true

        ImageCacheManager.loadImageViewForUrl("http://frismart.com/img/photo/larg_142583702483.PNG", placeHolderImage: nil, imageView: self.adImageView)

        self.autoHideTimer = NSTimer.scheduledTimerWithTimeInterval(kAutoHideCustomAdTimer, target:self, selector: #selector(ModalAdsViewController.autoHideLeave), userInfo: nil, repeats: false)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        AppData.sharedInstance.customAdOnDisplay = false

        self.autoHideTimer.invalidate()
        self.autoHideTimer = nil
    }

    @IBAction func clickDone(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(kHideModalAddNotification, object: nil)
    }

    func autoHideLeave() {
        NSNotificationCenter.defaultCenter().postNotificationName(kHideModalAddNotification, object: nil)
    }
}
