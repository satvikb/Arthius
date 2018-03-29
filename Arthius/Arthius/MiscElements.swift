//
//  MiscElements.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class KnobEdit : UIView {
    
    var panned = {(pan: UIPanGestureRecognizer) in}
    
    var panGesture : UIPanGestureRecognizer!;
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width))
        
        self.tag = lineStartTag+1;
        self.layer.cornerRadius = frame.width/2
        self.backgroundColor = UIColor.gray;
        self.isUserInteractionEnabled = true;
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    var boxCenter = CGPoint.zero
    
    @objc func handlePan(_ pan : UIPanGestureRecognizer){
//        if pan.state == .began {
//            boxCenter = self.center // store old button center
//        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
//            //            self.center = boxCenter // restore button center
//        } else {
//            let location = pan.translation(in: superview) // get pan location
//            self.center = CGPoint(x: boxCenter.x+location.x, y: boxCenter.y+location.y) // set button to where finger is
//            frameChanged()
//        }
        panned(pan);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
