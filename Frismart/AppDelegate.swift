//
//  AppDelegate.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var displayModalTimer: NSTimer!
    var window: UIWindow?
    var semaphore: dispatch_semaphore_t?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.semaphore = dispatch_semaphore_create(0)
        
        AppData.sharedInstance.activityIndicatorView = STActivityIndicatorView(frame: UIScreen.mainScreen().bounds)
        
        STConnectionManager.getData(onGetDataSuccess, onFailureHandler: onGetDataFailure)
        dispatch_semaphore_wait(self.semaphore!, DISPATCH_TIME_FOREVER)
        
        GMSServices.provideAPIKey(kGOOGLEMAPS_API_KEY)

        self.displayModalTimer = NSTimer.scheduledTimerWithTimeInterval(kDisplayCustomAdTimer, target:self, selector: #selector(AppDelegate.updateDisplayModal), userInfo: nil, repeats: true)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.hideModalAddViewController), name:kHideModalAddNotification, object: nil)


        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: custom ads modal Methods
    func updateDisplayModal() -> Void {
        guard AppData.sharedInstance.customAdOnDisplay == false else { return }

        NSNotificationCenter.defaultCenter().postNotificationName(kDisplayModalAddNotification, object: nil)
        self.displayModalTimer?.invalidate()
        self.displayModalTimer = nil
    }

    func hideModalAddViewController() {
        self.displayModalTimer = NSTimer.scheduledTimerWithTimeInterval(kDisplayCustomAdTimer, target:self, selector: #selector(AppDelegate.updateDisplayModal), userInfo: nil, repeats: true)
    }
    
    //MARK: Closure Methods
    private func onGetDataSuccess(data: JSON){
        print("Data loaded...")
        STDataParser.parseDataResponse(data)
        STConnectionManager.getCategories(onGetCategoriesSuccess, onFailureHandler: onGetCategoriesFailure)
    }
    
    private func onGetDataFailure(error: NSError){
        print("Get Data Error : \(error)")
        dispatch_semaphore_signal(self.semaphore!)
    }
    
    private func onGetCategoriesSuccess(data: JSON){
        
        // TODO : Insérer les informations dans Core Data
        print("Categories loaded...")
        STDataParser.parseCategoriesResponse(data)
        dispatch_semaphore_signal(self.semaphore!)
    }
    
    private func onGetCategoriesFailure(error: NSError){
        print("Get Categories Error : \(error)")
        dispatch_semaphore_signal(self.semaphore!)
    }
}

