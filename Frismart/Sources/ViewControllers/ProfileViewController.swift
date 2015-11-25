//
//  ProfileViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-28.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class ProfileViewController: STBaseViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userImageViewLabel: UILabel!
    @IBOutlet var userImageUpdateButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userFullNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var userLogOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
        self.setUserProfileValues()
    }
    
    private func initializeUI()->Void {
        self.userProfileImageView.withRoundCorners(self.userProfileImageView.frame.size.height/2)
        self.userImageViewLabel.text = NSLocalizedString("ProfileScreen_EditImage", comment:"")
        self.userLogOutButton.setTitle(NSLocalizedString("ProfileScreen_Logout", comment:""), forState: .Normal)
    }
    
    private func setUserProfileValues()->Void{
        self.userNameLabel.text = AppData.sharedInstance.user?.username
        self.userFullNameLabel.text = AppData.sharedInstance.user?.full_name
        self.userEmailLabel.text = AppData.sharedInstance.user?.email
    }
    
    func updateProfile(sender:UIButton){
        print("Send Profile Update")
    }
    
    @IBAction func clickOnEditPhoto(sender: AnyObject) {
        print("Take a Picture")
    }
    
    @IBAction func clickOnLogOut(sender: AnyObject) {
        print("Log Out")
    }
}