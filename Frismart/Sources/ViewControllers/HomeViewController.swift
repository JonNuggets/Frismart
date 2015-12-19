//
//  HomeViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import SwiftyJSON

let kTopViewHorizontalPadding  :CGFloat = 34.0

class HomeViewController: STBaseViewController, UIScrollViewDelegate {
    @IBOutlet var topStoresScrollView: UIScrollView!
    @IBOutlet var topCategoriesScrollView: UIScrollView!
    @IBOutlet var storesSectionLabel: UILabel!
    @IBOutlet var categoriesSectionLabel: UILabel!
    @IBOutlet var topStoresPageControlPlaceholderView: UIView!
    @IBOutlet var topCategoriesPageControlPlaceholderView: UIView!

    var currentTopCategoryView: TopCategoryView?
    var currentTopStoreView: TopStoreView?

    let topStoresPageControl = SMPageControl()
    var topStoresPageControlIsChangingPage: Bool = false

    let topCategoriesPageControl = SMPageControl()
    var topCategoriesPageControlIsChangingPage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topStoresScrollView.delegate = self
        self.topCategoriesScrollView.delegate = self
        self.initializeUI()
    }

    private func initializeUI()->Void {
        self.storesSectionLabel.text = NSLocalizedString("HomeScreen_StoresSectionTitle", comment:"")
        self.categoriesSectionLabel.text = NSLocalizedString("HomeScreen_CategoriesSectionTitle", comment:"")
        self.loadTopStoresViews()
        self.loadTopCategoriesViews()

        self.initializePageControls()
    }
    
    private func loadTopStoresViews()-> Void{
        var totalWidthSize: CGFloat = 0
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        for (var i = 0; i < AppData.sharedInstance.topStores?.count; i++){
            let topStoreView : TopStoreView = NSBundle.mainBundle().loadNibNamed(kTopStoreViewNibName, owner: self, options: nil)[0] as! TopStoreView
            
            topStoreView.store = (AppData.sharedInstance.topStores?[i])!
            topStoreView.display((AppData.sharedInstance.topStores?[i])!)
            
            topStoreView.frame.origin = CGPointMake(((screenSize.width+(kTopViewHorizontalPadding/2)) * CGFloat(i))+(kTopViewHorizontalPadding/2),0)
            topStoreView.frame.size = CGSizeMake(screenSize.width-kTopViewHorizontalPadding, self.topStoresScrollView.frame.height)

            topStoreView.storeDetailsButton.addTarget(self, action: "displayStoreDetails:", forControlEvents: .TouchUpInside)

            totalWidthSize = topStoreView.frame.origin.x + topStoreView.frame.width

            self.topStoresScrollView.addSubview(topStoreView)
        }

        self.topStoresScrollView.contentSize = CGSizeMake(totalWidthSize+(kTopViewHorizontalPadding/2), 1)
    }

    private func initializePageControls() -> Void{
        self.topStoresPageControl.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, self.topStoresPageControlPlaceholderView.frame.height)
        self.topStoresPageControl.frame.origin = CGPointMake(0, 0)
        self.topStoresPageControl.userInteractionEnabled = false
        self.topStoresPageControl.alignment = .Center
        self.topStoresPageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.topStoresPageControl.currentPageIndicatorTintColor = UIColor().frismartCurrentPageControlColor
        self.topStoresPageControl.numberOfPages = AppData.sharedInstance.topStores!.count
        self.topStoresPageControlPlaceholderView.addSubview(self.topStoresPageControl)

        self.topCategoriesPageControl.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, self.topCategoriesPageControlPlaceholderView.frame.height)
        self.topCategoriesPageControl.frame.origin = CGPointMake(0, 0)
        self.topCategoriesPageControl.userInteractionEnabled = false
        self.topCategoriesPageControl.alignment = .Center
        self.topCategoriesPageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.topCategoriesPageControl.currentPageIndicatorTintColor = UIColor().frismartCurrentPageControlColor
        self.topCategoriesPageControl.numberOfPages = AppData.sharedInstance.topCategories!.count
        self.topCategoriesPageControlPlaceholderView.addSubview(self.topCategoriesPageControl)
    }

    private func loadTopCategoriesViews() -> Void{
        var totalWidthSize: CGFloat = 0
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        for (var i = 0; i < AppData.sharedInstance.topCategories?.count; i++){
            let topCategoryView : TopCategoryView = NSBundle.mainBundle().loadNibNamed(kTopCategoryViewNibName, owner: self, options: nil)[0] as! TopCategoryView

            topCategoryView.category = (AppData.sharedInstance.topCategories?[i])!
            topCategoryView.display((AppData.sharedInstance.topCategories?[i])!)

            topCategoryView.frame.origin = CGPointMake(screenSize.width * CGFloat(i), 0)
            topCategoryView.frame.size = CGSizeMake(screenSize.width, self.topCategoriesScrollView.frame.height)

            topCategoryView.storesPerCategoryButton.addTarget(self, action: "displayStoresPerCategory:", forControlEvents: .TouchUpInside)

            totalWidthSize = topCategoryView.frame.origin.x + topCategoryView.frame.width

            self.topCategoriesScrollView.addSubview(topCategoryView)
        }

        self.topCategoriesScrollView.contentSize = CGSizeMake(totalWidthSize, 1)
    }

    func displayStoreDetails(sender: UIButton!) -> Void{
        self.currentTopStoreView  = (sender.superview as? TopStoreView)!
        performSegueWithIdentifier(kShowTopStoreDetailsSegue, sender: self)
        print("Afficher le detail de \(currentTopStoreView!.storeNameLabel.text)")
    }

    func displayStoresPerCategory(sender: UIButton!) -> Void{
        self.currentTopCategoryView = (sender.superview as? TopCategoryView)!
        performSegueWithIdentifier(kShowStoresForTopCategorySegue, sender: self)
        print("Afficher le detail de \(currentTopCategoryView!.categoryLabel.text)")
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

    // MARK: UIScrollViewDelegate methods

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.topStoresScrollView == scrollView {
            if self.topStoresPageControlIsChangingPage {
                return
            }

            self.topStoresPageControlIsChangingPage = true
        }
        else if self.topCategoriesScrollView == scrollView {
            if self.topCategoriesPageControlIsChangingPage {
                return
            }

            self.topCategoriesPageControlIsChangingPage = true
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
        let page:Int = Int(scrollView.contentOffset.x / (UIScreen.mainScreen().bounds.width))

        if self.topStoresScrollView == scrollView {
            self.topStoresPageControlIsChangingPage = false

            self.topStoresPageControl.currentPage = page
        }
        else if self.topCategoriesScrollView == scrollView {
            self.topCategoriesPageControlIsChangingPage = false

            self.topCategoriesPageControl.currentPage = page
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        let page:Int = Int(scrollView.contentOffset.x / (UIScreen.mainScreen().bounds.width))

        if self.topStoresScrollView == scrollView {
            self.topStoresPageControlIsChangingPage = false

            self.topStoresPageControl.currentPage = page
        }
        else if self.topCategoriesScrollView == scrollView {
            self.topCategoriesPageControlIsChangingPage = false

            self.topCategoriesPageControl.currentPage = page
        }
    }
}
