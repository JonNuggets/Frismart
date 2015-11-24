//
//  FavoritesViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-10.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class FavoritesViewController : STBaseTableViewController {
    
    var selectedStore: STStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppData.sharedInstance.favoriteStores.count)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kStandardHeightForRow
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let storeInfoCell: StoreDetailsInfoCell = tableView.dequeueReusableCellWithIdentifier(kStoreInfoTableViewCellIdentifier) as! StoreDetailsInfoCell
        return storeInfoCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let storeInfoCell : StoreDetailsInfoCell = cell as! StoreDetailsInfoCell
        storeInfoCell.display(AppData.sharedInstance.favoriteStores[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedStore  = AppData.sharedInstance.favoriteStores[indexPath.row]
        performSegueWithIdentifier(kShowFavoriteStoreSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! StoreDetailsViewController
        destinationViewController.currentStore = self.selectedStore
    }
}