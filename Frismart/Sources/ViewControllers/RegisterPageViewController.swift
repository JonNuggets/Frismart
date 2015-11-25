//
//  RegisterPageViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-20.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation


class RegisterPageViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var passwordTextField: STUITextField!
    @IBOutlet var usernameTextField: STUITextField!
    @IBOutlet var emailTextField: STUITextField!
    @IBOutlet var fullnameTextField: STUITextField!
    
    @IBOutlet var registerButton: UIButton!
    
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
        self.usernameTextField.delegate = self
        self.usernameTextField.text = ""
        self.usernameTextField.placeholder = NSLocalizedString("RegisterPage_UsernamePlaceholder", comment:"")
        
        self.passwordTextField.secureTextEntry = true
        self.passwordTextField.delegate = self
        self.passwordTextField.text = ""
        self.passwordTextField.placeholder = NSLocalizedString("RegisterPage_PasswordPlaceholder", comment:"")
        
        self.emailTextField.delegate = self
        self.emailTextField.text = ""
        self.emailTextField.placeholder = NSLocalizedString("RegisterPage_EmailPlaceholder", comment:"")
        
        self.fullnameTextField.delegate = self
        self.fullnameTextField.text = ""
        self.fullnameTextField.placeholder = NSLocalizedString("RegisterPage_FullnamePlaceholder", comment:"")
                
        self.registerButton.setTitle(NSLocalizedString("LoginPage_LoginButtonTitle", comment:""), forState: .Normal)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event);
        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField)-> Bool {
        return true
    }
    
    //MARK: Private Methods
    private func formIsValid() -> Bool {
        if self.usernameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty || self.emailTextField.text!.isEmpty || self.fullnameTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    
    @IBAction func clickOnLogin(sender: AnyObject) {
        
        if self.formIsValid() {
            print("Waiting for the register...")
            //STConnectionManager.login(self.usernameTextField.text!, password: self.passwordTextField.text!, onSuccessHandler: onLoginSuccess, onFailureHandler: nil)
        }
        else {
            let alertController = UIAlertController(title: "Frismart", message: "All the fields are required.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func onLoginSuccess() -> Void {
        print("Logged in...")
        AppData.sharedInstance.loggedIn = true
    }
    
    func onLoginFailure(error: NSError, message: String) -> Void {
        //TO DO
    }
}