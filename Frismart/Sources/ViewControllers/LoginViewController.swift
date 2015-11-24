//
//  LoginViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-28.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class LoginViewController: STBaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var pagesControllerView: UIView!
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.initializeUI()
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
}