//
//  LoginPageViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 15-11-19.
//  Copyright © 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

let kLOAD_VIEW_KEYBOARD_SHOW_Y_OFFSET   = CGFloat(-5.0)
let kKEYBOARD_VIEW_HIDDEN_Y_OFFSET      = CGFloat(0.0)

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var passwordTextField: STUITextField!
    @IBOutlet var usernameTextField: STUITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.view.endEditing(true)
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
        //self.clickOnLogin([])
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event);
        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField)-> Bool {
        return true
    }
    
    //
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            var newFrame:CGRect = self.view.frame
            
            if self.activeTextField == self.passwordTextField {
                newFrame.origin.y = kLOAD_VIEW_KEYBOARD_SHOW_Y_OFFSET
            }
    
            UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.frame = newFrame
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        print("YES")
        
        self.view.frame.origin.y = kKEYBOARD_VIEW_HIDDEN_Y_OFFSET
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