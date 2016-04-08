//
//  HomeViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import SwiftyJSON

let kTopViewHorizontalPadding: CGFloat = 34.0
let kTopStoresFrontPadding: CGFloat = 20.0
let kTopCategoriesFrontPadding: CGFloat = 10

let kHOMEVIEW_LONG_PRESS_DELAY: CFTimeInterval = 0.1

class HomeViewController: STBaseViewController {
    @IBOutlet var topStoresScrollView: UIScrollView!
    @IBOutlet var topCategoriesScrollView: UIScrollView!
    @IBOutlet var storesSectionLabel: UILabel!
    @IBOutlet var categoriesSectionLabel: UILabel!

    var currentTopCategoryView: TopCategoryView?
    var currentTopStoreView: TopStoreView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
    }

    private func initializeUI()->Void {
        self.storesSectionLabel.text = NSLocalizedString("HomeScreen_StoresSectionTitle", comment:"")
        self.categoriesSectionLabel.text = NSLocalizedString("HomeScreen_CategoriesSectionTitle", comment:"")

        self.topStoresScrollView.showsHorizontalScrollIndicator = false
        self.topStoresScrollView.showsVerticalScrollIndicator = false

        self.topCategoriesScrollView.showsHorizontalScrollIndicator = false
        self.topCategoriesScrollView.showsVerticalScrollIndicator = false

        self.loadTopStoresViews()
        self.loadTopCategoriesViews()
    }
    
    private func loadTopStoresViews()-> Void {
        var totalWidthSize: CGFloat = 0

        for (index, store) in AppData.sharedInstance.topStores!.enumerate() {
            let topStoreView : TopStoreView

            if DeviceType.IS_IPHONE_4_OR_LESS {
                topStoreView = NSBundle.mainBundle().loadNibNamed(kIphone4TopStoreViewNibName, owner: self, options: nil)[0] as! TopStoreView
            }
            else if DeviceType.IS_IPHONE_5 {
                topStoreView = NSBundle.mainBundle().loadNibNamed(kIphone5TopStoreViewNibName, owner: self, options: nil)[0] as! TopStoreView
            }
            else if DeviceType.IS_IPHONE_6 {
                topStoreView = NSBundle.mainBundle().loadNibNamed(kIphone6TopStoreViewNibName, owner: self, options: nil)[0] as! TopStoreView
            }
            else {
                topStoreView = NSBundle.mainBundle().loadNibNamed(kTopStoreViewNibName, owner: self, options: nil)[0] as! TopStoreView
            }
            
            topStoreView.store = store
            topStoreView.display(store)
            
            topStoreView.frame.origin = CGPointMake((kTopStoresFrontPadding * CGFloat(index+1)) + (topStoreView.frame.size.width * CGFloat(index)),0)
            topStoreView.frame.size = CGSizeMake(topStoreView.frame.size.width, self.topStoresScrollView.frame.height)

            totalWidthSize = topStoreView.frame.origin.x + topStoreView.frame.width

            if let pressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.displayStoreDetailsLongPressed(_:))) {
                pressGestureRecognizer.minimumPressDuration = kHOMEVIEW_LONG_PRESS_DELAY

                topStoreView.addGestureRecognizer(pressGestureRecognizer)
            }

            self.topStoresScrollView.addSubview(topStoreView)
        }

        self.topStoresScrollView.contentSize = CGSizeMake(totalWidthSize+kTopStoresFrontPadding, 1)
    }

    private func loadTopCategoriesViews() -> Void {
        var totalWidthSize: CGFloat = 0

        for (index, category) in AppData.sharedInstance.topCategories!.enumerate() {
            let topCategoryView : TopCategoryView = NSBundle.mainBundle().loadNibNamed(kTopCategoryViewNibName, owner: self, options: nil)[0] as! TopCategoryView

            topCategoryView.category = category
            topCategoryView.display(category)

            topCategoryView.frame.origin = CGPointMake((kTopCategoriesFrontPadding * CGFloat(index+1)) + (topCategoryView.frame.size.width * CGFloat(index)),0)
            topCategoryView.frame.size = CGSizeMake(topCategoryView.frame.size.width, self.topCategoriesScrollView.frame.height)

            totalWidthSize = topCategoryView.frame.origin.x + topCategoryView.frame.width

            if let pressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.displayStoresPerCategoryLongPressed(_:))) {
                pressGestureRecognizer.minimumPressDuration = kHOMEVIEW_LONG_PRESS_DELAY

                topCategoryView.addGestureRecognizer(pressGestureRecognizer)
            }

            self.topCategoriesScrollView.addSubview(topCategoryView)
        }

        self.topCategoriesScrollView.contentSize = CGSizeMake(totalWidthSize+kTopCategoriesFrontPadding+40, 1)
    }

    //MARK: UIGestureRecognizer Selector Methods

    func displayStoreDetailsLongPressed(longPress: UIGestureRecognizer) {
        if (longPress.state == UIGestureRecognizerState.Ended) {  // Began
            self.currentTopStoreView  = (longPress.view as? TopStoreView)!
            performSegueWithIdentifier(kShowTopStoreDetailsSegue, sender: self)
        }
    }

    func displayStoresPerCategoryLongPressed(longPress: UIGestureRecognizer) {
        if (longPress.state == UIGestureRecognizerState.Ended) {  // Began
            self.currentTopCategoryView = (longPress.view as? TopCategoryView)!
            performSegueWithIdentifier(kShowStoresForTopCategorySegue, sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowTopStoreDetailsSegue {
            let destinationViewController = segue.destinationViewController as! StoreDetailsViewController
            destinationViewController.currentStore = self.currentTopStoreView?.store
        }
        else if segue.identifier == kShowStoresForTopCategorySegue {
            let destinationViewController = segue.destinationViewController as! StoresPerCategoryViewController
            destinationViewController.stores = self.currentTopCategoryView?.category?.getStoresPerCategory()
        }
    }
}
