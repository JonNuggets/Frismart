//
//  SearchViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-24.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation
import CoreLocation

class SearchViewController : STBaseViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet var searchBackgroundView: UIView!
    @IBOutlet var textToSearch: STUITextField!
    @IBOutlet var searchTableView: UITableView!

    var searchResults = [STStore]()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.textToSearch.delegate = self
        
        self.searchTableView.delegate = self
        self.searchTableView.scrollEnabled = true
        self.searchTableView.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.textToSearch.resignFirstResponder()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        }
        else {
            self.locationManager.delegate = nil
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.searchTableView.hidden = false

        let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        self.searchStores(substring)
        return true
    }
    
    private func searchStores(textToSearch: String){
        self.searchResults = STHelpers.searchStoresByKeyWord(textToSearch)

        // Calculate distance for all the stores
        if let location = self.location {
            for store:STStore in self.searchResults {
                let currentStoreLocation: CLLocation = CLLocation(latitude: Double(store.lat)!, longitude: Double(store.lon)!)

                if let distance: CLLocationDistance = currentStoreLocation.distanceFromLocation(location) {
                    store.geoDistance = distance
                }
            }

            // sort distance from min to max
            self.searchResults = self.searchResults.sort({$0.geoDistance < $1.geoDistance})
        }

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

    //MARK: Closure Methods

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
    }
}
