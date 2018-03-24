//
//  BaseLevelRectangle.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit


//The core rectangle class used by ColorBox and SpeedBoost, detects line collisions
class BaseLevelRectangle : UIView {
    
    
    var lineEnter = {}
    
    init(frame : CGRect, rotation : CGFloat, box : Bool){
        //TODO deal with rotation and box
        
        super.init(frame: frame)
        self.transform = CGAffineTransform(rotationAngle: rotation);

        
    }
    
    //doesnt work for rotation
    func pointInRect(locInMain : CGPoint) -> Bool{
//        let f = self.frame
//
//        if(point.x > f.origin.x && point.x < f.origin.x+f.size.width && point.y > f.origin.y && point.y < f.origin.y+f.size.height){
//            return true
//        }
//        return false
        
        let locInSub = self.convert(locInMain, from: superview)
        
        if(self.bounds.contains(locInSub)){
            return true
        }
        return false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
