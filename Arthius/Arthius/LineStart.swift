//
//  LineStart.swift
//  Arthius
//
//  Created by Satvik Borra on 3/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class LineStart : UIView {
    
    var lineColor : Color!;
    var lineVelocity : CGVector!;
    
    var editable : Bool = false;
    var panGesture : UIPanGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
    init(frame: CGRect, _startVelocity : CGVector, _lineColor : Color, _editable : Bool){
        
        self.lineColor = _lineColor
        self.lineVelocity = _startVelocity;
        self.editable = _editable
        
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width))
        
        self.backgroundColor = UIColor.black;
        self.layer.cornerRadius = frame.width/2
        
        
        if(editable){
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            self.addGestureRecognizer(panGesture)
            
            //        TODO box (done)
            frameChangeKnob = KnobEdit(frame: propToRect(prop: CGRect(x: 2, y: 0, width: 0.5, height: 0.5), within: self.frame))
            frameChangeKnob.panned = {(pan: UIPanGestureRecognizer) in
                //in case
                if(self.editable == true){
                    self.handleFrameChangePan(pan: pan)
                }
            }
            self.addSubview(frameChangeKnob)

        }
        
    }
    
    
    var boxCenter = CGPoint.zero
    
    @objc func handlePan(_ pan : UIPanGestureRecognizer){
        if pan.state == .began {
            boxCenter = self.center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            //            self.center = boxCenter // restore button center
        } else {
            let location = pan.translation(in: superview) // get pan location
            self.center = CGPoint(x: boxCenter.x+location.x, y: boxCenter.y+location.y)
            frameChanged()
        }
    }
    
    
    var preLoc : CGPoint = CGPoint.zero
    
    func handleFrameChangePan(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            preLoc = self.frameChangeKnob.frame.origin
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            //            self.center = boxCenter // restore button center
        } else {
            let change = pan.translation(in: superview) // get pan location
            //            var originOffset = CGPoint.zero;
            
            var newX = preLoc.x+change.x
            var newY = preLoc.y+change.y

            var d = sqrt(pow(newX, 2) + pow(newY, 2))
            var r = frame.size.width
            var t = atan2(newY - preLoc.y, newX - preLoc.x)

            if(d > r){
                newX = r*cos(t) + preLoc.x;
                newY = r*sin(t) + preLoc.y;
            }
            
            self.frameChangeKnob.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: self.frameChangeKnob.frame.size)
//            updateSubViewsWithNewFrame()
            
            frameChanged()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
