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
    @IBOutlet var passwordTextField: STUITextField!
    @IBOutlet var usernameTextField: STUITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
    }
    
    private func initializeUI()->Void {
        self.logoImageView.image = UIImage(named: "Logo")?.imageWithColor(UIColor().frismartTableViewBackgroundColor)
        
        self.usernameTextField.secureTextEntry = false
        self.usernameTextField.delegate = self
        self.usernameTextField.text = ""
        self.usernameTextField.placeholder = "Email address"
        
        self.passwordTextField.secureTextEntry = true
        self.passwordTextField.delegate = self
        self.passwordTextField.text = ""
        self.passwordTextField.placeholder = "Password"
        
        self.loginButton.backgroundColor = UIColor().frismartDefaultBackgroundColor
        self.loginButton.setTitle("Connexion", forState: .Normal)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.forgotPasswordButton.setTitle("Mot de passe oublié?", forState: .Normal)
        
    }

    //MARK: UITextField Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.usernameTextField {
            self.usernameTextField.beginEditing()
        }
        else {
            self.passwordTextField.beginEditing()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == self.usernameTextField {
            self.usernameTextField.endEditing()
        }
        else {
            self.passwordTextField.endEditing()
        }
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
    }
    
    func onLoginFailure(error: NSError, message: String) -> Void {
        
    }
}