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
    var imaginaryCenter : CGPoint = CGPoint.zero;

    init(frame: CGRect, _startVelocity : CGVector, _lineColor : Color, _maxPropStartVelocity : CGVector){
        
        self.lineColor = _lineColor
        self.lineVelocity = _startVelocity;
//        self.editable = _editable
        self.maxPropStartVelocity = _maxPropStartVelocity;
        
        super.init(frame: CGRect(x: frame.origin.x-frame.width/2, y: frame.origin.y-frame.width/2, width: frame.width, height: frame.width))
        
        self.tag = lineStartTag
        
        self.backgroundColor = UIColor.black;
        self.layer.cornerRadius = frame.width/2
//        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.clipsToBounds = false
        self.layer.borderWidth = 2;
        
        self.isUserInteractionEnabled = true
        
        maxVectorRadius = self.frame.width
        imaginaryCenter = self.center
        
        if(editable){
            
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.cancelsTouchesInView = false;
            panGesture.delegate = self;
            self.addGestureRecognizer(panGesture)
            
            //        TODO box (done)
            var knobFrame = propToRect(prop: CGRect(x:0.5, y: 0.5, width: 0.5, height: 0.5), within: self.frame)
            centerLocation = knobFrame.origin
            knobFrame.origin = getKnobPointFromVector(velocityVector: _startVelocity) + centerLocation
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
            preLoc = self.frameChangeKnob.center
//            print(preLoc)
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {

        } else {
            panTranslation = pan.translation(in: frameChangeKnob) // get pan location
            let newCenter = preLoc + panTranslation

            let centerOfLine = centerLocation!
            let distFrom = newCenter - centerOfLine
            
            imaginaryCenter = newCenter

            if((distFrom.x*distFrom.x + distFrom.y*distFrom.y) < maxVectorRadius*maxVectorRadius){
                frameChangeKnob.center = newCenter
//                print("1_\(getCurrentKnobVectorNormalized())")
            }else{
                
                //TODO figure out why subtracting centerOfLine in the vector then adding it to the final point works
                let newBoundedCenter = CGVector(dx: imaginaryCenter.x-centerOfLine.x, dy: imaginaryCenter.y-centerOfLine.y).normalized()*maxVectorRadius
                let boundedCenterRaw = CGPoint(x: newBoundedCenter.dx, y: newBoundedCenter.dy)
                frameChangeKnob.center = boundedCenterRaw + centerOfLine
//                print("2_\(getCurrentKnobVectorNormalized())")
            }
            
            frameChanged()
        }
    }
    
    func getCurrentKnobVectorNormalized() -> CGVector{
        let newBoundedCenter = CGVector(dx: imaginaryCenter.x-centerLocation.x, dy: imaginaryCenter.y-centerLocation.y).normalized()
        return newBoundedCenter
    }
    
    func getKnobPointFromVector(velocityVector : CGVector) -> CGPoint{
//        vector/maxPropStartVelocity
        
        //used to load the knob at the right point based on start velocity
        //TODO - SLIGHTLY OFF, maybe because frame offsets not taken into account like above, and velocityVector has to be broken down/reversed based on above function to take into account that offset, gl.
        
        // start = normalized * max
        let vector : CGVector = (velocityVector/maxPropStartVelocity)*maxVectorRadius
        
        print("TODO Prop Vector To Knob Position: \(vector)")
        
//        normal = vector/vector.length
        // vector = normal * length = normal * (
        
        
        return CGPoint(x: vector.dx, y: vector.dy)
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
