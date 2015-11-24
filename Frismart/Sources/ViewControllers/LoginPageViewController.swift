//
//  LoginPageViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-19.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var passwordTextField: STUITextField!
    @IBOutlet var usernameTextField: STUITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
    }
    
    
    private func initializeUI()->Void {
        self.usernameTextField.secureTextEntry = false
        self.usernameTextField.delegate = self
        self.usernameTextField.text = ""
        self.usernameTextField.placeholder = NSLocalizedString("LoginPage_UsernamePlaceholder", comment:"")

        self.passwordTextField.secureTextEntry = true
        self.passwordTextField.delegate = self
        self.passwordTextField.text = ""
        self.passwordTextField.placeholder = NSLocalizedString("LoginPage_PasswordPlaceholder", comment:"")

        self.loginButton.setTitle(NSLocalizedString("LoginPage_LoginButtonTitle", comment:""), forState: .Normal)
        self.forgotPasswordButton.setTitle(NSLocalizedString("LoginPage_ForgetPasswordButtonTitle", comment:""), forState: .Normal)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.clickOnLogin([])
        return true
    }
    
    //MARK: Private Methods
    private func formIsValid() -> Bool {
        if self.usernameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    
    @IBAction func clickOnLogin(sender: AnyObject) {
        
        if self.formIsValid() {
            print("Waiting for the login...")
            self.startActivityIndicatorAnimation()
            STConnectionManager.login(self.usernameTextField.text!, password: self.passwordTextField.text!, onSuccessHandler: onLoginSuccess, onFailureHandler: nil)
        }
        else {
            let alertController = UIAlertController(title: "Frismart", message: "Username/Password is empty.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickOnPasswordRecall(sender: AnyObject) {
        print("Nouveau mot de passe a generer")
    }
    
    func onLoginSuccess() -> Void {
        print("Logged in...")
        AppData.sharedInstance.loggedIn = true
        self.stopActivityIndicatorAnimation()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationController?.pushViewController(profileViewController, animated: true)
        })
        
        
        
    
    }
    
    func onLoginFailure(error: NSError, message: String) -> Void {
        //TO DO
    }
}