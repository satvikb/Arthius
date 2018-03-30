//
//  LineStart.swift
//  Arthius
//
//  Created by Satvik Borra on 3/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class LineStart : UIView, UIGestureRecognizerDelegate {
    
    var lineColor : Color!;
    var lineVelocity : CGVector!;
    
    var maxPropStartVelocity : CGVector!;
    
    var editable : Bool = true; //TODO needed? always editable...
    var panGesture : UIPanGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
    var centerLocation : CGPoint!
    var maxVectorRadius : CGFloat!
    
    init(frame: CGRect, _startVelocity : CGVector, _lineColor : Color, _maxPropStartVelocity : CGVector){
        
        self.lineColor = _lineColor
        self.lineVelocity = _startVelocity;
//        self.editable = _editable
        self.maxPropStartVelocity = _maxPropStartVelocity;
        
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width))
        
        self.tag = lineStartTag
        
        self.backgroundColor = UIColor.black;
        self.layer.cornerRadius = frame.width/2
//        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.clipsToBounds = false
        self.layer.borderWidth = 2;
        
        self.isUserInteractionEnabled = true
        
        maxVectorRadius = self.frame.width
        
        if(editable){
            
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.cancelsTouchesInView = false;
            panGesture.delegate = self;
            self.addGestureRecognizer(panGesture)
            
            //        TODO box (done)
            let knobFrame = propToRect(prop: CGRect(x:0.5, y: 0.5, width: 0.5, height: 0.5), within: self.frame)
            centerLocation = knobFrame.origin
            frameChangeKnob = KnobEdit(frame: knobFrame)
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
    var panTranslation : CGPoint = CGPoint.zero
    
    func handleFrameChangePan(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            preLoc = self.frameChangeKnob.center//centerLocation/CGPoint(x: 2, y: 2)//CGPoint(x: self.frame.midX, y: self.frame.midY)//self.frameChangeKnob.frame.origin
            print(preLoc)
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            //            self.center = boxCenter // restore button center
        } else {
            panTranslation = pan.translation(in: frameChangeKnob) // get pan location
            let newCenter = preLoc + panTranslation
            //            var originOffset = CGPoint.zero;
            let centerOfLine = centerLocation!
            
            let distFrom = newCenter - centerOfLine
//            print(newCenter - centerOfLine)
            
            
            if((distFrom.x*distFrom.x + distFrom.y*distFrom.y) < maxVectorRadius*maxVectorRadius){
                frameChangeKnob.center = newCenter
            
            }else{
                let newBoundedCenter = getCurrentKnobVectorNormalized()*maxVectorRadius//CGVector(dx: distFrom.x, dy: distFrom.y).normalized()*maxVectorRadius
                let boundedCenterRaw = CGPoint(x: newBoundedCenter.dx, y: newBoundedCenter.dy)
                frameChangeKnob.center = boundedCenterRaw + centerOfLine
            }
            
            
////            let newX = preLoc.x+change.x
////            let newY = preLoc.y+change.y
////            let newPoint = CGPoint(x: newX, y: newY)
//            let r = frame.size.width
////
//            let p = newCenter
//            let c = centerLocation!
////
//            let vX : CGFloat = p.x - c.x;
//            let vY : CGFloat = p.y - c.y;
//            let magV : CGFloat = sqrt(vX*vX + vY*vY);
//            let aX = c.x + vX / magV * r;
//            let aY = c.y + vY / magV * r;
//
//            let clippedPoint : CGPoint = CGPoint(x: aX, y: aY) //TODO this has chance to be nan
//            print(preLoc, clippedPoint, change, p, c, p - c)
//            self.frameChangeKnob.center = (clippedPoint + centerOfLine) - CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            
            
            
            frameChanged()
        }
    }
    
    func getCurrentKnobVectorNormalized() -> CGVector{
        let distFrom = (self.frameChangeKnob.center+panTranslation) - centerLocation
        
        return CGVector(dx: distFrom.x, dy: distFrom.y).normalized()
    }
    
    func getPointFromVector(vector : CGVector){
//        vector/maxPropStartVelocity
        
        //used to load the knob at the right point based on start velocity
        //TODO
        
    }
    
    func pointAbs(_ point: CGPoint) -> CGPoint{
        return CGPoint(x: abs(point.x), y: abs(point.y))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointForTargetView = self.frameChangeKnob.convert(point, from: self)
        if(self.frameChangeKnob.bounds.contains(pointForTargetView)){
            return self.frameChangeKnob//.hitTest(point, with:event)
        }
        return super.hitTest(point, with: event)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view == frameChangeKnob)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
