//
//  CustomView.swift
//  TODO
//
//  Created by rajneesh on 14/05/19.
//  Copyright © 2019 rajneesh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var borderWidth: Int = 1
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var roundedCornerRadius: Int = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customizeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customizeView()
    }
    
    func customizeView() {
        self.layer.cornerRadius = CGFloat(roundedCornerRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
    }
}
