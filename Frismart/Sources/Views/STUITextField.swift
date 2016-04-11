//
//  STUITextField.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-09-23.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import Foundation

let kUITEXTFIELD_BORDER_SIZE_NORMAL         = CGFloat(1.0)
let kUITEXTFIELD_BORDER_SIZE_HIGHLIGHTED    = CGFloat(2.0)
let kUITEXTFIELD_DEFAULT_PADDING_SIZE       = CGFloat(20.0)

@IBDesignable class STUITextField: UITextField {
    @IBInspectable var roundborder: Bool = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.paddingLeft()
    }
    
    private func paddingLeft() {
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: kUITEXTFIELD_DEFAULT_PADDING_SIZE, height: kUITEXTFIELD_DEFAULT_PADDING_SIZE)
        self.leftViewMode = UITextFieldViewMode.Always
        self.leftView = paddingView
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        if self.roundborder {
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true

            self.layer.borderColor = UIColor.grayColor().CGColor
            self.layer.borderWidth = 0.5

            self.layer.contentsScale = UIScreen.mainScreen().scale
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOffset = CGSizeZero
            self.layer.shadowRadius = 5.0
            self.layer.shadowOpacity = 0.5
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }
    }
}