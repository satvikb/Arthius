//
//  BaseLevelRectangle.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

//The core rectangle class used by ColorBox and SpeedBoost, detects line collisions
class BaseLevelRectangle : GameUIElement {
    
    var lineEnter = {}
    
    init(frame : CGRect, rotation : CGFloat, box : Bool){
        //TODO deal with rotation and box
        
        super.init(frame: frame)
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.transform = CGAffineTransform(rotationAngle: rotation);
    }
    
    //doesnt work for rotation
//    func pointInRect(locInMain : CGPoint) -> Bool{
//        let locInSub = self.convert(locInMain, from: superview)
//        
//        if(self.bounds.contains(locInSub)){
//            return true
//        }
//        return false;
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
