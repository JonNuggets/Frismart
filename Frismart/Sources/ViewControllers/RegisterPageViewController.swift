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

    var activeTextField: STUITextField?
    
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
                
        self.registerButton.setTitle(NSLocalizedString("RegisterPage_RegisterButtonTitle", comment:""), forState: .Normal)
    }
    
    //MARK: TextField Delegate
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

    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.activeTextField = textField as? STUITextField
    }

    func textFieldDidEndEditing(textField: UITextField)
    {
        self.activeTextField = nil
    }
    
    //MARK: Private Methods
    private func formIsValid() -> Bool {
        if self.usernameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty || self.emailTextField.text!.isEmpty || self.fullnameTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    private func clearTextFields()->Void{
        self.emailTextField.text = ""
        self.fullnameTextField.text = ""
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    //MARK: Register Button
    @IBAction func clickOnRegister(sender: AnyObject) {
        
        if self.formIsValid() {
            self.startActivityIndicatorAnimation()
            STConnectionManager.register(self.emailTextField.text!, fullname: self.fullnameTextField.text!, username: self.usernameTextField.text!, password: self.passwordTextField.text!, onSuccessHandler:onRegisterSuccess, onFailureHandler: onRegisterFailure)
        }
        else {
            let alertController = UIAlertController(title: "Frismart", message: NSLocalizedString("Error_EmptyFields", comment: ""), preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: Closure functions
    func onRegisterSuccess() -> Void {
        self.stopActivityIndicatorAnimation()
        
        AppData.sharedInstance.loggedIn = true
        
        let alertController = UIAlertController(title: "Frismart", message: NSLocalizedString("RegisterPage_RegisterSuccess", comment: ""), preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func onRegisterFailure(error: NSError) -> Void {
        self.stopActivityIndicatorAnimation()
        
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "Frismart", message: NSLocalizedString("Error_RegisterFailed", comment: ""), preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.clearTextFields()
            
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
}