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
        
        self.locationManager.delegate = self
        STHelpers.initializeLocationManager(self.locationManager)
        self.initializeUI()
    }

    private func initializeUI()->Void {
        self.loadCategoriesViews()
        self.loadMarkersOnMap(self.currentCategoryIconView)
    }
    
    func loadCategoriesViews() {
        self.setAllCategoriesIconView()
        
        for (var i = 0; i < AppData.sharedInstance.categories?.count; i++){
            let categoryIconView : CategoryIconView = NSBundle.mainBundle().loadNibNamed(kCategoryIconViewNibName, owner: self, options: nil)[0] as! CategoryIconView
            
            categoryIconView.display((AppData.sharedInstance.categories?[i])!)
            
            categoryIconView.frame.origin = CGPointMake(categoryIconView.frame.width * CGFloat(i + 1) + 15.0 * (CGFloat(i + 1) + 1), 12.0)
            categoryIconView.categoryIconButton.addTarget(self, action: "displayStoresPerCategory:", forControlEvents: .TouchUpInside)
            
            self.categoriesScrollView.contentSize =
CGSizeMake(categoryIconView.frame.width * CGFloat(((AppData.sharedInstance.categories?.count)! + 1)) + 15.0 * (CGFloat((AppData.sharedInstance.categories?.count)! + 2)), 60)
            
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
        
        categoryIconView.categoryIconButton.addTarget(self, action: "displayStoresPerCategory:", forControlEvents: .TouchUpInside)
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
            
            self.loadMarkersOnMap(categoryIconView)
        }
        self.mapView.delegate = self
    }
    
    func loadMarkersOnMap(categoryIconView: CategoryIconView) {
        var category: STCategory?
        
        self.currentCategoryIconView = categoryIconView
        var stores: [STStore]?
        
        if self.categoryIconViewsList.indexOf(categoryIconView) == 0 {
            stores = AppData.sharedInstance.stores
        }
        else {
            category = (AppData.sharedInstance.categories?[self.categoryIconViewsList.indexOf(categoryIconView)! - 1])!
            stores = category!.getStoresPerCategory()
        }
        
        for store in stores! {
            let target : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (store.lat)!.doubleValue, longitude: (store.lon)!.doubleValue)
            let camera = GMSCameraPosition(target: target, zoom: 15, bearing: 0, viewingAngle: 0)
            
            let marker = GMSMarker()
            marker.position = camera.target
            marker.map = self.mapView
            
            let categoryPin = String(format: "Category_%@Pin", store.getCategory().removePunctuation())
            
            marker.icon = UIImage(named: categoryPin)?.imageWithColor(UIColor().frismartDefaultBackgroundColor)
            marker.title = store.store_name
            self.markersList.append(marker)
            //self.fitAllMarkers()
            
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
        
        let cameraPosition = GMSCameraPosition(target: locations.first!.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.setCamera(cameraPosition))
        self.locationManager.stopUpdatingLocation()
    }
}