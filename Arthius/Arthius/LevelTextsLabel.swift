//
//  LevelTextsLabel.swift
//  Arthius
//
//  Created by Satvik Borra on 3/29/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class LevelTextsLabel : Label {
    
    var tapped = {}
    
    var tapToContinueView : Label!; //TODO, replace with small arrow or sth
    
    init(frame: CGRect, text: String, _outPos: CGPoint, textColor: UIColor, valign: VAlign, _insets: Bool, hidden: Bool) {
        
        super.init(frame: frame, text: text, _outPos: _outPos, textColor: textColor, valign: valign, _insets: _insets)
        self.isHidden = hidden;
        self.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1).cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.7)
        self.textAlignment = .center
        self.layer.zPosition = 1000
        self.isUserInteractionEnabled = true
        tapToContinueView = Label(frame: propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0.2, height: 0.2), within: self.frame), text: "", _outPos: propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0, height: 0), within: self.frame).origin, textColor: textColor, valign: valign, _insets: _insets)
        self.addSubview(tapToContinueView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapped();
    }
}
