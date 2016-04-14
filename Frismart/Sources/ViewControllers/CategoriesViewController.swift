//
//  CategoriesViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-10.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class CategoriesViewController : STBaseTableViewController {
    
    var stores: [STStore]?

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.sharedInstance.categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoryCell: CategoryCell = tableView.dequeueReusableCellWithIdentifier(kCategoryTableViewCellIdentifier) as! CategoryCell
        return categoryCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let categoryCell : CategoryCell = cell as! CategoryCell
        categoryCell.display(AppData.sharedInstance.categories[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.stores  = AppData.sharedInstance.categories[indexPath.row].getStoresPerCategory() as [STStore]
        performSegueWithIdentifier(kGetStoresPerCategorySegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! StoresPerCategoryViewController
        destinationViewController.stores = self.stores
    }
}
