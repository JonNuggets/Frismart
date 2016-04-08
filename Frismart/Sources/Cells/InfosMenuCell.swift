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
        self.userImageView.withRoundCorners(self.userImageView.frame.size.height/2)
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
        
        self.userImageView.image = AppData.sharedInstance.user?.profileImageView?.image
        
        let userNames: [String] = (AppData.sharedInstance.user?.full_name.componentsSeparatedByString(" "))!
        
        self.userNameLabel.text = userNames[0] + " "
        if userNames.count > 1 {
                self.userNameLabel.text = self.userNameLabel.text! + userNames[1][0]
        }
        
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