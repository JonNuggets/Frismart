//
//  StoreDetailsViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-30.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

let kStoreDetailsHeaderSectionHeight                    :CGFloat = CGFloat(109)
let kStoreDetailsDescriptionCellHeight                  :CGFloat = CGFloat(50)
let kStoreDetailsFullDescriptionDefaultCellHeight       :CGFloat = CGFloat(0)
let kStoreDetailsMapCellHeight                          :CGFloat = CGFloat(200)
let kStoreDetailsContactCellHeight                      :CGFloat = CGFloat(60)
let kStoreDetailsImagesCellHeight                       :CGFloat = CGFloat(155)
let kStoreDetailsRateCellHeight                         :CGFloat = CGFloat(130)

let kLaunchPlansWithItinerary   :String = "http://maps.apple.com/?saddr=%@,%@&daddr=%@,%@"

enum STStoreDetailsScreen : Int {
    case ShowDescriptionIndex   = 0
    case FullDescriptionIndex   = 1
    case MapIndex               = 2
    case ContactIndex           = 3
    case ImagesIndex            = 4
    case RateIndex              = 5
    
    static var count: Int {
        return STStoreDetailsScreen.RateIndex.rawValue+1
    }
}

class StoreDetailsViewController : STBaseTableViewController, GMSMapViewDelegate, CLLocationManagerDelegate, FloatRatingViewDelegate {
    var currentStore: STStore?
    var storePhotos: [STPhoto]?
    var storeDetailsThumbViewList: [StoreDetailsThumbView]?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var getItineraryButton: UIButton?
    var floatRatingView: FloatRatingView?
    var showFullDescription : Bool = false
    var fullDescriptionHeight: CGFloat = CGFloat(0.0)
    var favoriteButton: UIButton?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.delegate = self
        STHelpers.initializeLocationManager(self.locationManager)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STStoreDetailsScreen.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let storeDetailsInfoCell: StoreDetailsInfoCell = tableView.dequeueReusableCellWithIdentifier(kStoreDetailsTableViewCellIdentifier) as! StoreDetailsInfoCell
            storeDetailsInfoCell.display(self.currentStore!)
            self.favoriteButton = storeDetailsInfoCell.favoriteButton
            self.updateFavoriteIconInfo()
            return storeDetailsInfoCell
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == STStoreDetailsScreen.ShowDescriptionIndex.rawValue) {
            return kStoreDetailsDescriptionCellHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.FullDescriptionIndex.rawValue) && (self.showFullDescription == false) {
            return kStoreDetailsFullDescriptionDefaultCellHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.FullDescriptionIndex.rawValue) && (self.showFullDescription == true) {
            return self.fullDescriptionHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.MapIndex.rawValue) {
            return kStoreDetailsMapCellHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.ContactIndex.rawValue) {
            return kStoreDetailsContactCellHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.ImagesIndex.rawValue && self.storePhotos?.count > 0) {
            return kStoreDetailsImagesCellHeight
        }
        if (indexPath.row == STStoreDetailsScreen.ImagesIndex.rawValue && self.storePhotos?.count == 0) {
            return kStoreDetailsImagesCellHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.RateIndex.rawValue) {
            return kStoreDetailsRateCellHeight
        }
        
        return 0.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kStoreDetailsHeaderSectionHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == STStoreDetailsScreen.ShowDescriptionIndex.rawValue) {
            let storeDescriptionCell = tableView.dequeueReusableCellWithIdentifier(kStoreDescTableViewCellIdentifier)
            return storeDescriptionCell!
        }
        
        if (indexPath.row == STStoreDetailsScreen.FullDescriptionIndex.rawValue) {
            let storeFullDescriptionCell: StoreDetailsFullDescriptionCell = tableView.dequeueReusableCellWithIdentifier(kStoreFullDescTableViewCellIdentifier) as! StoreDetailsFullDescriptionCell
            return storeFullDescriptionCell
        }
        
        if (indexPath.row == STStoreDetailsScreen.MapIndex.rawValue) {
            let storeDetailsMapCell: StoreDetailsMapCell = tableView.dequeueReusableCellWithIdentifier(kStoreMapTableViewCellIdentifier) as! StoreDetailsMapCell
            return storeDetailsMapCell
        }
        
        if (indexPath.row == STStoreDetailsScreen.ContactIndex.rawValue) {
            let storeContactCell: StoreDetailsContactsCell = tableView.dequeueReusableCellWithIdentifier(kStoreContactTableViewCellIdentifier) as! StoreDetailsContactsCell
            return storeContactCell
        }
        
        if (indexPath.row == STStoreDetailsScreen.ImagesIndex.rawValue) {
            let storeDetailsPicturesCell = tableView.dequeueReusableCellWithIdentifier(kStoreImagesTableViewCellIdentifier) as! StoreDetailsPicturesCell
            return storeDetailsPicturesCell
        }
        
        if (indexPath.row == STStoreDetailsScreen.RateIndex.rawValue) {
            let storeRateCell = tableView.dequeueReusableCellWithIdentifier(kStoreRateTableViewCellIdentifier)
            return storeRateCell!
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.storePhotos = self.currentStore?.getPhotos()
        
        if (indexPath.row == STStoreDetailsScreen.FullDescriptionIndex.rawValue) {
            let storeFullDescriptionCell: StoreDetailsFullDescriptionCell = cell as! StoreDetailsFullDescriptionCell
            storeFullDescriptionCell.display(self.currentStore!)

            //++
            let newHeight = storeFullDescriptionCell.storeDescLabel.optimalHeight()
            self.fullDescriptionHeight = newHeight
        }
        
        if (indexPath.row == STStoreDetailsScreen.MapIndex.rawValue) {
            
            let storeDetailsMapCell: StoreDetailsMapCell = cell as! StoreDetailsMapCell
            let target : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (self.currentStore?.lat)!.doubleValue, longitude: (self.currentStore?.lon)!.doubleValue)
            let camera = GMSCameraPosition(target: target, zoom: 15, bearing: 0, viewingAngle: 0)
            
            let marker = GMSMarker()
            marker.position = camera.target
            marker.map = storeDetailsMapCell.mapView
            marker.icon = UIImage(named: "LogoIcon")?.imageWithColor(UIColor().frismartDefaultBackgroundColor)
            
            storeDetailsMapCell.mapView.myLocationEnabled = true
            storeDetailsMapCell.mapView.camera = camera
            storeDetailsMapCell.mapView.delegate = self
        }
        
        if (indexPath.row == STStoreDetailsScreen.ImagesIndex.rawValue && self.storePhotos?.count > 0) {
            self.storeDetailsThumbViewList = [StoreDetailsThumbView]()
            let storeDetailsPicturesCell: StoreDetailsPicturesCell = cell as! StoreDetailsPicturesCell

            for (index, photo) in self.storePhotos!.enumerate() {
                let storeDetailsThumbView : StoreDetailsThumbView = NSBundle.mainBundle().loadNibNamed(kStoreDetailsThumbNibName, owner: self, options: nil)[0] as! StoreDetailsThumbView

                ImageCacheManager.loadImageViewForUrl(photo.thumb_url, placeHolderImage: nil, imageView: storeDetailsThumbView.thumbnailImageView)

                storeDetailsThumbView.thumbnailButton.addTarget(self, action: #selector(StoreDetailsViewController.displayLargeView(_:)), forControlEvents: .TouchUpInside)
                storeDetailsThumbView.frame.origin = CGPointMake(storeDetailsThumbView.frame.width * CGFloat(index) + kTopViewHorizontalPadding * (CGFloat(index) + 1), 16.0)

                storeDetailsPicturesCell.storePhotosScrollView.contentSize = CGSizeMake(storeDetailsThumbView.frame.width * CGFloat((self.storePhotos?.count)!) + kTopViewHorizontalPadding * (CGFloat((self.storePhotos?.count)! + 1)), storeDetailsPicturesCell.storePhotosScrollView.frame.size.height)
                storeDetailsPicturesCell.storePhotosScrollView.addSubview(storeDetailsThumbView)
                storeDetailsThumbViewList?.append(storeDetailsThumbView)
            }
        }
        
        if (indexPath.row == STStoreDetailsScreen.ContactIndex.rawValue) {
            
            let storeDetailsContactsCell: StoreDetailsContactsCell = cell as! StoreDetailsContactsCell
            
            self.checkContactValues(storeDetailsContactsCell)

            storeDetailsContactsCell.storeAppelButton.addTarget(self, action: #selector(StoreDetailsViewController.callStore(_:)), forControlEvents: .TouchUpInside)
            storeDetailsContactsCell.storeEmailButton.addTarget(self, action: #selector(StoreDetailsViewController.emailStore(_:)), forControlEvents: .TouchUpInside)
            storeDetailsContactsCell.storeWebsiteButton.addTarget(self, action: #selector(StoreDetailsViewController.visitStoreWebsite(_:)), forControlEvents: .TouchUpInside)
            storeDetailsContactsCell.storeItineraryButton.addTarget(self, action: #selector(StoreDetailsViewController.getItineraryToStore(_:)), forControlEvents: .TouchUpInside)
            
            self.getItineraryButton = storeDetailsContactsCell.storeItineraryButton
        }
        
        if (indexPath.row == STStoreDetailsScreen.RateIndex.rawValue) {
            let storeDetailsRatingCell: StoreDetailsRatingCell = cell as! StoreDetailsRatingCell
            
            if AppData.sharedInstance.loggedIn == false {
                storeDetailsRatingCell.storeRatingView.editable = false
            }
            
            self.floatRatingView = storeDetailsRatingCell.storeRatingView
            self.floatRatingView?.delegate = self
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == STStoreDetailsScreen.ShowDescriptionIndex.rawValue) {
            if self.showFullDescription == false {
                self.showFullDescription = true
            }
            else {
                self.showFullDescription = false
            }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
        }
    }
    
    //MARK : Action Buttons Methods
    func callStore(sender:UIButton!){
        let callString: String = String(format: "tel://%@", (self.currentStore?.phone_no.removePunctuation())!)
        UIApplication.sharedApplication().openURL(NSURL(string: callString)!)
    }
    
    func emailStore(sender:UIButton!){
        let emailString: String = String(format: "mailto://%@", (self.currentStore?.email)!)
        UIApplication.sharedApplication().openURL(NSURL(string: emailString)!)
    }
    
    func visitStoreWebsite(sender:UIButton!){
        var websiteWithHTTP: String = String()
        
        if self.currentStore?.website.rangeOfString("http://") == nil {
            websiteWithHTTP = "http://" + (self.currentStore?.website)!
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: websiteWithHTTP)!)
    }
    
    func getItineraryToStore(sender:UIButton!){
    
        if (self.currentLocation?.coordinate.latitude == nil || self.currentLocation?.coordinate.longitude == nil) {
            self.getItineraryButton?.enabled = false
        }
        else {
            let currentUserLatitude: String = String((self.currentLocation?.coordinate.latitude)!)
            let currentUserLongitude: String = String((self.currentLocation?.coordinate.longitude)!)
            let itineraryString: String = String(format: kLaunchPlansWithItinerary, currentUserLatitude, currentUserLongitude, (currentStore?.lat)!, (currentStore?.lon)!)
            UIApplication.sharedApplication().openURL(NSURL(string: itineraryString)!)
        }
    }
    
    @IBAction func clickOnFavorite(sender: UIButton) {
        if self.favoriteButton!.selected == true {
            AppData.sharedInstance.favoriteStores.removeObject(self.currentStore!)
        }
        else {
            AppData.sharedInstance.favoriteStores.append(self.currentStore!)
        }
        self.updateFavoriteIconInfo()
    }
    
    //MARK : Private Methods
    private func updateFavoriteIconInfo() -> Void {
        var favoriteFound = false
        
        self.favoriteButton!.setImage(UIImage(named: "StoreDetails_Like_Checked")!.imageWithColor(UIColor.redColor()), forState: .Normal)
        
        self.favoriteButton!.enabled = true
        self.favoriteButton!.selected = false
        self.favoriteButton!.highlighted = false

        if let currentStore = self.currentStore {
            for favoriteItem in AppData.sharedInstance.favoriteStores {
                if favoriteItem.store_id == currentStore.store_id {
                    self.favoriteButton!.setImage(UIImage(named: "StoreDetails_Like_Checked")!.imageWithColor(UIColor.redColor()), forState: .Selected)
                    self.favoriteButton!.selected = true
                    favoriteFound = true
                }
            }
        }
        
        if favoriteFound == false {
            self.favoriteButton!.setImage(UIImage(named: "StoreDetails_Like_Unchecked")!.imageWithColor(UIColor.redColor()), forState: .Normal)
        }
    }
    
    
    private func checkContactValues(storeDetailsContactsCell: StoreDetailsContactsCell)->Void {
        if (self.currentStore?.phone_no.isEmpty == true) {
            storeDetailsContactsCell.storeAppelButton.enabled = false
        }
        
        if (currentStore?.email.isEmpty == true) {
            storeDetailsContactsCell.storeEmailButton.enabled = false
        }
        
        if (currentStore?.website.isEmpty == true) {
            storeDetailsContactsCell.storeWebsiteButton.enabled = false
        }
        
        if (!CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .Denied) {
            storeDetailsContactsCell.storeItineraryButton.enabled = false
        }
    }
    
    private func getPlacemark() -> Void {
        let geoCoder = CLGeocoder()
        
        AppData.sharedInstance.user?.currentLocation = self.currentLocation
        
        geoCoder.reverseGeocodeLocation(self.currentLocation!, completionHandler: { (placeMarksArray, error) -> Void in
            if error == nil && placeMarksArray!.count > 0 {
                AppData.sharedInstance.user?.currentPlacemark = placeMarksArray![placeMarksArray!.endIndex - 1]
            }
        })
    }
    
    func displayLargeView(sender:UIButton){
        if let storeDetailsThumbView = sender.superview as? StoreDetailsThumbView {
            print("Index : \(self.storeDetailsThumbViewList?.indexOf(storeDetailsThumbView))")
        }
    }
    
    //MARK : CoreLocation Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if (self.getItineraryButton?.enabled == false) {
            self.getItineraryButton?.enabled = true
        }
        
        if let _ : CLLocation = newLocation {
            self.currentLocation = newLocation
            self.getPlacemark()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.getItineraryButton?.enabled = false
    }
    
    //MARK: Float Rating View Methods
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        if AppData.sharedInstance.loggedIn == true {
            self.floatRatingView?.editable = false
            
            self.startActivityIndicatorAnimation()
            STConnectionManager.postRating(String(self.floatRatingView?.rating), store: self.currentStore!, onSuccessHandler: self.onPostRatingSuccess, onFailureHandler: self.onPostRatingFailure)
        }
        else {
            let alertController = UIAlertController(title: "Frismart", message: NSLocalizedString("StoreDetailsScreen_AlertView_Rating", comment:""), preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    //MARK: Closure Methods
    func onPostRatingSuccess() {
        let newRatingCount: Int = Int((self.currentStore?.rating_count)!)! + 1
        let oldTotal: Float = (self.currentStore?.rating_total.floatValue)! * (self.currentStore?.rating_count.floatValue)!
        let newRatingTotal: Float = (oldTotal + (self.floatRatingView?.rating)!) / Float(newRatingCount)
        
        self.currentStore?.rating_count = String(newRatingCount)
        self.currentStore?.rating_total = String(newRatingTotal)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            self.stopActivityIndicatorAnimation()
        })
        self.floatRatingView?.editable = true
    }
    
    func onPostRatingFailure(error: NSError) {
        self.floatRatingView?.editable = true
        self.stopActivityIndicatorAnimation()
    }
}
