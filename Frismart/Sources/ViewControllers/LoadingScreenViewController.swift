//
//  LoadingScreenViewController.swift
//  Frismart
//
//  Created by James Laurenstin on 2016-04-14.
//  Copyright © 2016 Karl Mounguengui. All rights reserved.
//

import UIKit

import SwiftyJSON

class LoadingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        STConnectionManager.getData(self.onGetDataSuccess, onFailureHandler: self.onGetDataFailure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
            return false;
        }
        else {
            return true;
        }
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- Closure Methods

    private func onGetDataSuccess(data: JSON){
        print("Data loaded...")

        STDataParser.parseDataResponse(data)
        STConnectionManager.getCategories(self.onGetCategoriesSuccess, onFailureHandler: self.onGetCategoriesFailure)
    }

    private func onGetDataFailure(error: NSError){
        print("Get Data Error : \(error)")

        if AppData.sharedInstance.reachability.isReachable() == false {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                appDelegate.loadOfflineModeData()

                self.displayErrorMessage()
            }
        }
    }

    private func onGetCategoriesSuccess(data: JSON){
        print("Categories loaded...")
        STDataParser.parseCategoriesResponse(data)

        // All data was successfuylly loaded, we can store those data for later use.
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.locallySaveOfflineModeData()

            self.launchMainMenu()
        }
    }

    private func onGetCategoriesFailure(error: NSError){
        print("Get Categories Error : \(error)")

        if AppData.sharedInstance.reachability.isReachable() == false {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                appDelegate.loadOfflineModeData()

                self.displayErrorMessage()
            }
        }
    }

    private func launchMainMenu() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        // launch the main menu now that all the data is loaded
        if let mainMenuVC = storyBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as? SWRevealViewController {
            self.presentViewController(mainMenuVC, animated:false, completion:nil)
        }
    }

    private func displayErrorMessage(peformAction: Bool = true) {
        let alertController = UIAlertController(title: NSLocalizedString("AppTitle", comment:""), message: NSLocalizedString("Error_NoInternetDetectedMessageNoDataAvailable", comment:""), preferredStyle: .Alert)

        let OkAction = UIAlertAction(title: NSLocalizedString("Alert_TitleOKButton", comment:""), style: .Cancel) { (action) in
            if peformAction {
                self.launchMainMenu()
            }
        }
        alertController.addAction(OkAction)

        self.presentViewController(alertController, animated: true) {
        }
    }
}
