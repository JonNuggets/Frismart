//
//  MapViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-10-28.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class MapViewController: STBaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //@IBOutlet var categoriesScrollView: UIScrollView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var categoriesScrollView: UIScrollView!
    var categoryIconViewsList: [CategoryIconView] = [CategoryIconView]()
    var currentCategoryIconView: CategoryIconView = CategoryIconView()
    var markersList: [GMSMarker] = [GMSMarker]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        STHelpers.initializeLocationManager(self.locationManager)
        self.initializeUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationManager.startUpdatingLocation()
    }

    private func initializeUI()->Void {
        self.loadCategoriesViews()
        self.loadMarkersOnMap(self.currentCategoryIconView)
    }
    
    func loadCategoriesViews() {
        self.setAllCategoriesIconView()

        for (index, category) in AppData.sharedInstance.categories.enumerate() {
            let categoryIconView : CategoryIconView = NSBundle.mainBundle().loadNibNamed(kCategoryIconViewNibName, owner: self, options: nil)[0] as! CategoryIconView
            
            categoryIconView.display(category)
            
            categoryIconView.frame.origin = CGPointMake(categoryIconView.frame.width * CGFloat(index + 1) + 15.0 * (CGFloat(index + 1) + 1), 12.0)
            categoryIconView.categoryIconButton.addTarget(self, action: #selector(MapViewController.displayStoresPerCategory(_:)), forControlEvents: .TouchUpInside)
            
            self.categoriesScrollView.contentSize = CGSizeMake(categoryIconView.frame.width * CGFloat(((AppData.sharedInstance.categories.count) + 1)) + 15.0 * (CGFloat((AppData.sharedInstance.categories.count) + 2)), 60)
            
            self.categoriesScrollView.addSubview(categoryIconView)
            self.categoryIconViewsList.append(categoryIconView)
        }
    }
    
    //MARK: Private Functions
    private func setAllCategoriesIconView(){
        let categoryIconView : CategoryIconView = NSBundle.mainBundle().loadNibNamed(kCategoryIconViewNibName, owner: self, options: nil)[0] as! CategoryIconView
        
        categoryIconView.categoryIconBackgroundView.backgroundColor = UIColor.whiteColor()
        categoryIconView.categoryIconButton.selected = true
        categoryIconView.categoryIconButton.highlighted = false
        categoryIconView.categoryIconButton.setTitle("Tout", forState: .Selected)
        categoryIconView.categoryIconButton.setTitleColor(UIColor().frismartDefaultBackgroundColor, forState: UIControlState.Selected)
        categoryIconView.categoryIconImageView.image = nil
        
        categoryIconView.categoryIconButton.addTarget(self, action: #selector(MapViewController.displayStoresPerCategory(_:)), forControlEvents: .TouchUpInside)
        categoryIconView.frame.origin = CGPointMake(15.0 , 12.0)
        
        self.categoriesScrollView.contentSize = CGSizeMake(categoryIconView.frame.width + kTopViewHorizontalPadding, 60)

        self.categoriesScrollView.addSubview(categoryIconView)
        self.categoryIconViewsList.append(categoryIconView)
        self.currentCategoryIconView = categoryIconView
    }
    
    //MARK: Buttons Actions
    func displayStoresPerCategory(sender: UIButton!) {
        self.mapView.clear()
        self.markersList = [GMSMarker]()
        
        if let categoryIconView = sender.superview as? CategoryIconView {
            if self.currentCategoryIconView == categoryIconView {
                return
            }
            
            self.currentCategoryIconView.categoryIconButton.selected = false
            self.currentCategoryIconView.categoryIconBackgroundView.backgroundColor = UIColor.clearColor()
            self.currentCategoryIconView.categoryIconImageView.image = self.currentCategoryIconView.categoryIconImageView.image?.imageWithColor(UIColor.whiteColor())
            self.currentCategoryIconView.categoryIconButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            if self.currentCategoryIconView.categoryIconImageView.image == nil {
                self.currentCategoryIconView.categoryIconButton.setTitle("Tout", forState: .Normal)
            }
    
            categoryIconView.categoryIconButton.selected = true
            categoryIconView.categoryIconBackgroundView.backgroundColor = UIColor.whiteColor()
            categoryIconView.categoryIconImageView.image = categoryIconView.categoryIconImageView.image?.imageWithColor(UIColor().frismartDefaultBackgroundColor)

            self.loadMarkersOnMap(categoryIconView)
        }
        //self.mapView.delegate = self
    }
    
    func loadMarkersOnMap(categoryIconView: CategoryIconView) {
        var category: STCategory?
        
        self.currentCategoryIconView = categoryIconView
        var stores: [STStore]?
        
        if self.categoryIconViewsList.indexOf(categoryIconView) == 0 {
            stores = AppData.sharedInstance.stores
        }
        else {
            category = (AppData.sharedInstance.categories[self.categoryIconViewsList.indexOf(categoryIconView)! - 1])
            stores = category!.getStoresPerCategory()
        }
        
        for store in stores! {
            let target : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: store.lat.doubleValue, longitude: store.lon.doubleValue)
            let camera = GMSCameraPosition(target: target, zoom: 15, bearing: 0, viewingAngle: 0)
            
            let marker = STPlaceMarker(store: store)
            marker.position = camera.target
            marker.map = self.mapView
            
            //marker.title = store.store_name
            self.markersList.append(marker)
            
            self.mapView.myLocationEnabled = true
        }
    }
    
    func revealCurrentLocation(sender: UIBarButtonItem) {
        self.locationManager.startUpdatingLocation()
    }

    func fitAllMarkers() {
        var bounds = GMSCoordinateBounds()
        
        
        for marker in self.markersList {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds))
    }

    
    //MARK: CLLocationManager Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let cameraPosition = GMSCameraPosition(target: locations.last!.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.setCamera(cameraPosition))
        self.locationManager.stopUpdatingLocation()
    }
    
    //MARK: GMSMapView Delegate Methods
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as! STPlaceMarker
        
        let storeDetailsMarkerView : StoreDetailsMarkerView = NSBundle.mainBundle().loadNibNamed("StoreDetailsMarkerView", owner: self, options: nil)[0] as! StoreDetailsMarkerView
        
        storeDetailsMarkerView.display(placeMarker.store)
        
        return storeDetailsMarkerView
    }
    
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as! STPlaceMarker
        
        let storeDetailsMarkerView : StoreDetailsMarkerView = NSBundle.mainBundle().loadNibNamed("StoreDetailsMarkerView", owner: self, options: nil)[0] as! StoreDetailsMarkerView
        
        storeDetailsMarkerView.display(placeMarker.store)
        
        return storeDetailsMarkerView
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        return false
    }
}