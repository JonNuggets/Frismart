//
//  ProfileViewController.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-28.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

class ProfileViewController: STBaseViewController {
    
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
    }
    
    private func initializeUI()->Void {
        
    }
}