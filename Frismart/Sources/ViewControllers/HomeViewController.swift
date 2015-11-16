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
let kTopStoreViewVerticalPadding    :CGFloat = 8.0


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
        self.loadTopStoresViews()
        self.loadTopCategoriesViews()
    }
    
    private func loadTopStoresViews()-> Void{
        
        for (var i = 0; i < AppData.sharedInstance.topStores?.count; i++){
            let topStoreView : TopStoreView = NSBundle.mainBundle().loadNibNamed(kTopStoreViewNibName, owner: self, options: nil)[0] as! TopStoreView
            
            topStoreView.store = (AppData.sharedInstance.topStores?[i])!
            topStoreView.display((AppData.sharedInstance.topStores?[i])!)
            topStoreView.frame.origin = CGPointMake(topStoreView.frame.width * CGFloat(i) + kTopViewHorizontalPadding * (CGFloat(i) + 1), kTopStoreViewVerticalPadding)
            topStoreView.storeDetailsButton.addTarget(self, action: "displayStoreDetails:", forControlEvents: .TouchUpInside)

            self.topStoresScrollView.contentSize = CGSizeMake(topStoreView.frame.width * CGFloat((AppData.sharedInstance.topStores?.count)!) + kTopViewHorizontalPadding * (CGFloat((AppData.sharedInstance.topStores?.count)! + 1)), self.topStoresScrollView.frame.size.height)
            
            self.topStoresScrollView.addSubview(topStoreView)
        }
    }
    
    private func loadTopCategoriesViews() -> Void{
        
        for (var i = 0; i < AppData.sharedInstance.topCategories?.count; i++){
            let topCategoryView : TopCategoryView = NSBundle.mainBundle().loadNibNamed(kTopCategoryViewNibName, owner: self, options: nil)[0] as! TopCategoryView
    
            topCategoryView.category = (AppData.sharedInstance.topCategories?[i])!
            topCategoryView.display((AppData.sharedInstance.topCategories?[i])!)
            topCategoryView.frame.origin = CGPointMake(topCategoryView.frame.width * CGFloat(i) + kTopViewHorizontalPadding * (CGFloat(i) + 1), kTopStoreViewVerticalPadding)
            topCategoryView.storesPerCategoryButton.addTarget(self, action: "displayStoresPerCategory:", forControlEvents: .TouchUpInside)
            
            self.topCategoriesScrollView.contentSize = CGSizeMake(topCategoryView.frame.width * CGFloat((AppData.sharedInstance.topCategories?.count)!) + kTopViewHorizontalPadding * (CGFloat((AppData.sharedInstance.topCategories?.count)! + 1)), self.topCategoriesScrollView.frame.size.height)
            
            self.topCategoriesScrollView.addSubview(topCategoryView)
        }
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
        if segue.identifier == kShowStoresForTopCategorySegue {
            let destinationViewController = segue.destinationViewController as! StoresPerCategoryViewController
            destinationViewController.stores = self.currentTopCategoryView?.category?.getStoresPerCategory()
        }
    }
}