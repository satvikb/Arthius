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
    
    var editable : Bool = false;
    var panGesture : UIPanGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
    var centerLocation : CGPoint!
    var maxVectorRadius : CGFloat!
    
    init(frame: CGRect, _startVelocity : CGVector, _lineColor : Color, _editable : Bool){
        
        self.lineColor = _lineColor
        self.lineVelocity = _startVelocity;
        self.editable = _editable
        
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
    
    func handleFrameChangePan(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            preLoc = centerLocation/CGPoint(x: 2, y: 2)//CGPoint(x: self.frame.midX, y: self.frame.midY)//self.frameChangeKnob.frame.origin
            print(preLoc)
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            //            self.center = boxCenter // restore button center
        } else {
            let change = pan.translation(in: frameChangeKnob) // get pan location
            //            var originOffset = CGPoint.zero;
            
            let newX = preLoc.x+change.x
            let newY = preLoc.y+change.y
            let newPoint = CGPoint(x: newX, y: newY)
//            var d = sqrt(pow(newX, 2) + pow(newY, 2))
            let r = frame.size.width
//            var t = atan2(newY - preLoc.y, newX - preLoc.x)
//
//            if(d > r){
//                newX = r*cos(t) + preLoc.x;
//                newY = r*sin(t) + preLoc.y;
//            }
//
//            self.frameChangeKnob.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: self.frameChangeKnob.frame.size)
////            updateSubViewsWithNewFrame()
            
            
//            https://math.stackexchange.com/questions/127613/closest-point-on-circle-edge-from-point-outside-inside-the-circle
//            https://stackoverflow.com/questions/300871/best-way-to-find-a-point-on-a-circle-closest-to-a-given-point
            // C⃗ =A⃗ +r(B⃗ −A⃗ )||B⃗ −A⃗ ||
//            let o = preLoc //origin
//            let clippedPoint = o + (r * (newPoint - o)/((newPoint-o).length()))
            let p = newPoint
            let c = preLoc
            
            let vX : CGFloat = p.x - c.x;
            let vY : CGFloat = p.y - c.y;
            let magV : CGFloat = sqrt(vX*vX + vY*vY);
            let aX = c.x + vX / magV * r;
            let aY = c.y + vY / magV * r;
            
            let clippedPoint : CGPoint = CGPoint(x: aX, y: aY) //TODO this has chance to be nan
            print(clippedPoint, newPoint, change)
            self.frameChangeKnob.frame = CGRect(origin: clippedPoint/*-CGPoint(x: self.frameChangeKnob.frame.origin.x, y: self.frameChangeKnob.frame.origin.y)*/, size: self.frameChangeKnob.frame.size)

            
            
            frameChanged()
        }
    }
    
    func pointAbs(_ point: CGPoint) -> CGPoint{
        return CGPoint(x: abs(point.x), y: abs(point.y))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Convert the point to the target view's coordinate system.
        // The target view isn't necessarily the immediate subview
//        CGPoint pointForTargetView = [self.targetView convertPoint:point fromView:self];
//
//        if (CGRectContainsPoint(self.targetView.bounds, pointForTargetView)) {
//
//            // The target view may have its view hierarchy,
//            // so call its hitTest method to return the right hit-test view
//            return [self.targetView hitTest:pointForTargetView withEvent:event];
//        }
//
//        return [super hitTest:point withEvent:event];
        
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
