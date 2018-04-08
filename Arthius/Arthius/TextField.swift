//
//  TextField.swift
//  Arthius
//
//  Created by Satvik Borra on 3/25/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class TextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
