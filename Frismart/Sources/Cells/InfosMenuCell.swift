//
//  InfosMenuCell.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

let kProfileMenuBorderwidth : CGFloat = CGFloat(3)

class InfosMenuCell : UITableViewCell {
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userNearestStoreLabel: UILabel!
    @IBOutlet var userLocationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.userImageView.layer.borderWidth = kProfileMenuBorderwidth
        self.userImageView.layer.masksToBounds = false
        self.userImageView.layer.borderColor = UIColor().frismartDefaultBackgroundColor.CGColor
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2
        self.userNameLabel.textColor = UIColor().frismartTableViewBackgroundColor
        self.userNearestStoreLabel.textColor = UIColor().frismartTableViewBackgroundColor
        self.userLocationLabel.textColor = UIColor().frismartTableViewBackgroundColor
        self.temperatureLabel.textColor = UIColor().frismartTableViewBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userImageView.image = nil
        self.userNameLabel.text = ""
        self.userNearestStoreLabel.text = ""
        self.userLocationLabel.text = ""
        self.temperatureLabel.text = ""
    }
    
    func display() -> Void{
        self.userNameLabel.text = AppData.sharedInstance.user?.full_name
        
        if AppData.sharedInstance.user?.currentLocation != nil {
            self.userNearestStoreLabel.text = STHelpers.getNearestStore().store_name
        }
        
        
        
        if (AppData.sharedInstance.user?.currentPlacemark != nil){
            let locality = AppData.sharedInstance.user?.currentPlacemark?.locality
            let country = AppData.sharedInstance.user?.currentPlacemark?.country
            self.userLocationLabel.text = String(format: "%@, %@", locality!, country!)
        }

        if AppData.sharedInstance.weather != nil {
            self.temperatureLabel.text = String(AppData.sharedInstance.weather!) + "º"
        }
    }
}