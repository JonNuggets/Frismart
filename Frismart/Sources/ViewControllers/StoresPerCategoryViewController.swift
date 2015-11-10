//
//  StoresPerCategoryViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-16.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

let kStandardHeightForRow   :CGFloat = 83.0

class StoresPerCategoryViewController: STBaseTableViewController {

    var stores: [STStore]?
    var store: STStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stores?.count)!
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
        storeInfoCell.display(stores![indexPath.row])
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.store  = stores![indexPath.row]
        performSegueWithIdentifier(kGetStoreDetailsSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! StoreDetailsViewController
        destinationViewController.currentStore = self.store
    }
}