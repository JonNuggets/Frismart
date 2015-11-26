//
//  LoginViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-28.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

let kSIGNIN_PASSWORD_KEYBOARD_SHOW_Y_OFFSET         = CGFloat(-140.0)
let kSIGNUP_FIRSTLASTNAME_KEYBOARD_SHOW_Y_OFFSET    = CGFloat(-140.0)
let kSIGNUP_USERNAME_KEYBOARD_SHOW_Y_OFFSET         = CGFloat(-180.0)
let kSIGNUP_PASSWORD_KEYBOARD_SHOW_Y_OFFSET         = CGFloat(-220.0)
let kKEYBOARD_VIEW_HIDDEN_Y_OFFSET                  = CGFloat(0.0)

class LoginViewController: STBaseViewController, UITextFieldDelegate {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var pagesControllerView: UIView!
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.initializeUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event);
        self.view.endEditing(true)
    }

    private func initializeUI()->Void {
        var controllerArray : [UIViewController] = []
        
        let loginPageController : LoginPageViewController = LoginPageViewController(nibName: "LoginPageViewController", bundle: nil)
        loginPageController.title = NSLocalizedString("LoginScreen_SignInPageTitle", comment:"")
        controllerArray.append(loginPageController)
        
        let registerPageViewController : RegisterPageViewController = RegisterPageViewController(nibName: "RegisterPageViewController", bundle: nil)
        registerPageViewController.title = NSLocalizedString("LoginScreen_SignUpPageTitle", comment:"")
        controllerArray.append(registerPageViewController)
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor().frismartDefaultBackgroundColor),
            .MenuItemFont(UIFont(name: "Exo2-SemiBold", size: 18.0)!),
            .SelectedMenuItemLabelColor(UIColor().frismartDefaultBackgroundColor),
            .MenuHeight(50.0),
            //.MenuItemWidth(self.view.frame.width/3),
            .CenterMenuItems(true)
        ]

        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.pagesControllerView.addSubview(pageMenu!.view)
    }


    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

            var newFrame:CGRect = self.view.frame

            if self.pageMenu!.currentPageIndex == 0 {
                if let loginPageController = self.pageMenu!.controllerArray[0] as? LoginPageViewController {
                    if loginPageController.activeTextField == loginPageController.passwordTextField {
                        newFrame.origin.y = kSIGNIN_PASSWORD_KEYBOARD_SHOW_Y_OFFSET
                    }
                }
            }
            else if self.pageMenu!.currentPageIndex == 1 {
                if let registerPageViewController = self.pageMenu!.controllerArray[1] as? RegisterPageViewController {
                    if registerPageViewController.activeTextField == registerPageViewController.fullnameTextField {
                        newFrame.origin.y = kSIGNUP_FIRSTLASTNAME_KEYBOARD_SHOW_Y_OFFSET
                    }
                    else if registerPageViewController.activeTextField == registerPageViewController.usernameTextField {
                        newFrame.origin.y = kSIGNUP_USERNAME_KEYBOARD_SHOW_Y_OFFSET
                    }
                    else if registerPageViewController.activeTextField == registerPageViewController.passwordTextField {
                        newFrame.origin.y = kSIGNUP_PASSWORD_KEYBOARD_SHOW_Y_OFFSET
                    }
                }
            }

            UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.frame = newFrame
                }, completion: nil)
        }
    }

    func keyboardWillHide(sender: NSNotification) {

        self.view.frame.origin.y = kKEYBOARD_VIEW_HIDDEN_Y_OFFSET
    }

}