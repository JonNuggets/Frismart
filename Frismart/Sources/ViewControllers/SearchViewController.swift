//
//  SearchViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-24.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class SearchViewController : STBaseViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {
    
    @IBOutlet var searchBackgroundView: UIView!
    @IBOutlet var textToSearch: STUITextField!
    @IBOutlet var searchTableView: UITableView!
    var searchResults = [STStore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textToSearch.delegate = self
        
        self.searchTableView.delegate = self
        self.searchTableView.scrollEnabled = true
        self.searchTableView.hidden = true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.searchTableView.hidden = false
        
        let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        self.searchStores(substring)
        return true
    }
    
    
    private func searchStores(textToSearch: String){
        self.searchResults = [STStore]()
        self.searchResults = STHelpers.searchStoresByKeyWord(textToSearch)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.searchTableView.reloadData()
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kStandardHeightForRow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let storeInfoCell: StoreDetailsInfoCell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! StoreDetailsInfoCell
        return storeInfoCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let storeInfoCell : StoreDetailsInfoCell = cell as! StoreDetailsInfoCell
        storeInfoCell.display(self.searchResults[indexPath.row])
    }
    
}