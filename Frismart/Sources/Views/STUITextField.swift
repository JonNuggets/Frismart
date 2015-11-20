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

class STUITextField: UITextField {
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
}