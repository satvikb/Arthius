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
    
    var lineDirectionRect : UIView!;
    
    var maxPropStartVelocity : CGVector!;
    
    var editable : Bool = true; //TODO needed? always editable...
    var panGesture : UIPanGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
//    var centerLocation : CGPoint!
    var maxVectorRadius : CGFloat!
//    var imaginaryCenter : CGPoint = CGPoint.zero;

    init(f: CGRect, _startVelocity : CGVector, _lineColor : Color, _maxPropStartVelocity : CGVector){
        let scaledStart = _startVelocity/CGVector(dx: 1, dy: UIScreen.main.bounds.width/UIScreen.main.bounds.height);
        
        self.lineColor = _lineColor
        self.lineVelocity = scaledStart
//        self.editable = _editable
        self.maxPropStartVelocity = _maxPropStartVelocity;
        
        super.init(frame: CGRect(x: f.origin.x-f.width/2, y: f.origin.y-f.width/2, width: f.width, height: f.width))
        
        self.tag = lineStartTag
        
        self.backgroundColor = UIColor.black;
        self.layer.cornerRadius = frame.width/2
//        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.clipsToBounds = false
        self.layer.borderWidth = 2;
        
        self.isUserInteractionEnabled = true
        
        
        lineDirectionRect = UIView(frame: CGRect(origin: CGPoint(x: self.frame.width/4, y: self.frame.height/2), size: CGSize(width: self.frame.width/2, height: self.frame.height*0.1)))
        lineDirectionRect.backgroundColor = UIColor.yellow
        lineDirectionRect.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        lineDirectionRect.transform = CGAffineTransform(rotationAngle: angle(point1: CGPoint(x: lineVelocity.dx, y: lineVelocity.dy), point2: CGPoint.zero));
        self.addSubview(lineDirectionRect)
        
        
        maxVectorRadius = self.frame.width
//        imaginaryCenter = self.center
        
        
//        let testCenter = UIView(frame: CGRect(origin: CGPoint(x: self.frame.width/2, y: self.frame.width/2), size: CGSize(width: 30, height: 30)))
//        testCenter.backgroundColor = UIColor.red
//        self.addSubview(testCenter)
        
        if(editable){
            
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.cancelsTouchesInView = false;
            panGesture.delegate = self;
            self.addGestureRecognizer(panGesture)
            
            //        TODO box (done)
            let knobFrame = propToRect(prop: CGRect(x:0.5, y: 0.5, width: 0.2, height: 0.2), within: self.frame)
//            knobFrame.origin = getKnobPointFromVector(velocityVector: _startVelocity) + knobFrame.origin
            frameChangeKnob = KnobEdit(frame: knobFrame)
            let offset = CGPoint(x: self.frame.width/2, y: self.frame.width/2)

            frameChangeKnob.center = getKnobPointFromVector(velocityVector: scaledStart) + offset
//            print("S \(frameChangeKnob.center)")
            frameChangeKnob.panned = {(pan: UIPanGestureRecognizer) in
                //in case
                if(self.editable == true){
                    self.handleFrameChangePan(pan: pan)
                }
            }
            self.addSubview(frameChangeKnob)

        }
        
    }

    func angle(point1 : CGPoint, point2 : CGPoint) -> CGFloat{
        let o = CGPoint(x: point2.x-point1.x, y: point2.y-point1.y)
        let bearingRad : CGFloat = CGFloat(atan2f(Float(o.y), Float(o.x)))
        return bearingRad
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
//            self.updateKnobPosition(panTranslation: CGPoint.zero)
            frameChanged()
        }
    }
    
    
    var preLoc : CGPoint = CGPoint.zero
    var panTranslation : CGPoint = CGPoint.zero
    
    
    func handleFrameChangePan(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            preLoc = self.frameChangeKnob.center
//            print(preLoc)
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {

        } else {
            panTranslation = pan.translation(in: frameChangeKnob) // get pan location
            
            updateKnobPosition(panTranslation: panTranslation)
            frameChanged()
        }
    }
    
    func updateKnobPosition(panTranslation: CGPoint){
        let newCenter = preLoc + panTranslation
        
//        let centerOfLine = centerLocation!
        let distFrom = newCenter - CGPoint(x: self.frame.width/2, y: self.frame.width/2)
        
//        imaginaryCenter = newCenter-CGPoint(x: frameChangeKnob.frame.width/2, y: frameChangeKnob.frame.height/2)
        
        if((distFrom.x*distFrom.x + distFrom.y*distFrom.y) < maxVectorRadius*maxVectorRadius){
            frameChangeKnob.center = newCenter
            //                print("1_\(getCurrentKnobVectorNormalized())")
        }else{
            
            //TODO figure out why subtracting centerOfLine in the vector then adding it to the final point works
            let newBoundedCenter = CGVector(dx: newCenter.x/*-self.center.x*/, dy: newCenter.y/*-self.center.y*/).normalized()*maxVectorRadius
            let boundedCenterRaw = CGPoint(x: newBoundedCenter.dx, y: newBoundedCenter.dy)
            frameChangeKnob.center = boundedCenterRaw + CGPoint(x: self.frame.width/2, y: self.frame.width/2)
            
            //TODO: basically use similar simple statement above, currently out of bounds get unsynced from rouch
            
            
            //                print("2_\(getCurrentKnobVectorNormalized())")
        }
        
        let v = getCurrentKnobVectorNormalized()
        lineDirectionRect.transform = CGAffineTransform(rotationAngle: angle(point1: CGPoint(x: v.dx, y: v.dy), point2: CGPoint.zero));

    }
    
    func getCurrentKnobVectorNormalized() -> CGVector{
        //TODO from knob to vector doesnt work well either - fix Vector to knob first though
//        let newBoundedCenter = CGVector(dx: imaginaryCenter.x-centerLocation.x, dy: imaginaryCenter.y-centerLocation.y).normalized()
        let offset = CGPoint(x: self.frame.width/2, y: self.frame.width/2)
        
        let x = frameChangeKnob.center.x
        let y = frameChangeKnob.center.y
        let nx = frameChangeKnob.center.x-offset.x
        let ny = frameChangeKnob.center.y-offset.y
        let d = sqrt(x*x + y*y)
        let s = (d/(maxVectorRadius))
        let newBoundedCenter = CGVector(dx: nx, dy: ny).normalized() * (s > 1 ? 1 : s)//(CGVector(dx: frameChangeKnob.center.x-offset.x, dy: frameChangeKnob.center.y-offset.y))//* (CGVector(dx: (frameChangeKnob.center.x-offset.x)/maxVectorRadius, dy: (frameChangeKnob.center.y-offset.y)/maxVectorRadius))
//        print("T",newBoundedCenter, maxVectorRadius, d)
        return newBoundedCenter
    }
    
    func getKnobPointFromVector(velocityVector : CGVector) -> CGPoint{
//        vector/maxPropStartVelocity
        
        //used to load the knob at the right point based on start velocity
        //TODO - SLIGHTLY OFF, maybe because frame offsets not taken into account like above, and velocityVector has to be broken down/reversed based on above function to take into account that offset, gl.
        
//        data.startVelocity = lineStart.getCurrentKnobVectorNormalized()*lineStart.maxPropStartVelocity*CGVector(dx: 1, dy: UIScreen.main.bounds.width/UIScreen.main.bounds.height)
        let vector : CGVector = (velocityVector/maxPropStartVelocity)*(maxVectorRadius/1.5)
        
        print("TODO Prop Vector To Knob Position: \(vector)_\(velocityVector) \(velocityVector/maxPropStartVelocity)")
        
//        normal = vector/vector.length
        // vector = normal * length = normal * (
        
        
        return CGPoint(x: vector.dx, y: vector.dy)
    }
    
    func pointAbs(_ point: CGPoint) -> CGPoint{
        return CGPoint(x: abs(point.x), y: abs(point.y))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if(editable){
            let pointForTargetView = self.frameChangeKnob.convert(point, from: self)
            if(self.frameChangeKnob.bounds.contains(pointForTargetView)){
                return self.frameChangeKnob//.hitTest(point, with:event)
            }
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
