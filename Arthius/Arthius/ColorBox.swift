//
//  ColorBox.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

/*
 This will be:
    Simple touch by line to change color
    Split into two sides, required and new color depends on entry side
*/

struct LineState : Equatable{
    var step1 : Bool = false;
    var step2 : Bool = false;
}

class ColorBox :  UIView {
    
    var leftColor : Color!;
    var rightColor : Color!;
    var middlePropWidth : CGFloat!;
    
    var bodyView : UIView!//BaseLevelRectangle!;
    
    var backgroundView : UIView!;
    var leftView : UIView!;
    var rightView : UIView!;
    
    
    var lineStates : [String : LineState] = [:]
    
    var stageView : UIView;
    
    var rotation : CGFloat = 0
    var knobFrame : CGRect!;
    
    //To edit in level editor
    var editable : Bool! = false;
    var panGesture : UIPanGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
    init(frame: CGRect, _rotation: CGFloat, box: Bool, _leftColor : Color, _rightColor : Color, backgroundColor : Color, _middlePropWidth : CGFloat, _stageView : UIView, _editable : Bool = false) {
        rotation = _rotation;
        leftColor = _leftColor;
        rightColor = _rightColor;
        middlePropWidth = _middlePropWidth;
        stageView = _stageView;
        editable = _editable;
        
//        print("F \(frame)")
        super.init(frame: frame)//, rotation: rotation, box: box)
        
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.transform = CGAffineTransform(rotationAngle: rotation);
        
        self.backgroundColor = UIColor.clear//ColorBox.ColorToUIColor(col: backgroundColor)
        
        if(editable){
            self.layer.borderWidth = 3;
            self.layer.borderColor = UIColor.orange.cgColor
        }
        
        bodyView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))//, rotation: rotation, box: box)
        
        bodyView.layer.borderWidth = 3;
        bodyView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(bodyView)
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundView.backgroundColor = ColorBox.ColorToUIColor(col: backgroundColor)
        bodyView.addSubview(backgroundView)
        
        //rotation should be handled by parent
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height))
        leftView.backgroundColor = ColorBox.ColorToUIColor(col: leftColor)
//        leftView.transform = CGAffineTransformMakeRotation(rotation);
        bodyView.addSubview(leftView)
        
        rightView = UIView(frame: CGRect(x: frame.width/2+((middlePropWidth/2)*frame.width), y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height))
//        rightView.transform = CGAffineTransformMakeRotation(rotation);
        rightView.backgroundColor = ColorBox.ColorToUIColor(col: rightColor)
        bodyView.addSubview(rightView)
        
        
        //editable
        if(editable){
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            self.addGestureRecognizer(panGesture)
            
    //        TODO box (done)
            knobFrame = propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0.4, height: 0.1), within: bodyView.frame)
            frameChangeKnob = KnobEdit(frame: knobFrame)
            frameChangeKnob.panned = {(pan: UIPanGestureRecognizer) in
                //in case
                if(self.editable == true){
                    self.handleFrameChangePan(pan: pan)
                }
            }
            bodyView.addSubview(frameChangeKnob)
        }
    }
    
    func pointInRightRect(locInMain : CGPoint) -> Bool{
        //TODO test if superview.superview exists
        
        let locInSub = rightView.convert(locInMain, from: stageView)
        
        if(rightView.bounds.contains(locInSub)){
            return true
        }
        return false;
    }
    
    func pointInLeftRect(locInMain : CGPoint) -> Bool{
        //TODO test if superview.superview exists
        let locInSub = leftView.convert(locInMain, from: stageView)
        
        if(leftView.bounds.contains(locInSub)){
            return true
        }
        return false;
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
    
    var preFrame : CGRect = CGRect.zero
    var knobPre : CGRect = CGRect.zero
    
    func handleFrameChangePan(pan: UIPanGestureRecognizer){

        if pan.state == .began {
            preFrame = bodyView.frame
            knobPre = frameChangeKnob.frame
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            //            self.center = boxCenter // restore button center
//            frameChangeKnob.frame = knobPre
        } else {
            var change = pan.translation(in: self) // get pan location
//            var originOffset = CGPoint.zero;
            let oChange = change
//            change = CGPoint(x: change.x/cos(rotation), y: change.y/sin(rotation))
            print(oChange, change)
//            var newKnobFrame : CGRect = propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0.4, height: 0.1), within: bodyView.frame)
//            newKnobFrame.size = CGSize(width: newKnobFrame.width, height: newKnobFrame.width)
            
            
            var newKnobLoc = knobPre.origin+change;
            
            
            
            var newWidth = preFrame.size.width+change.x
            var newHeight = preFrame.size.height+change.y
            
            let minWidth = propToFloat(prop: 0.1, scaleWithX: true)
            if(newWidth < minWidth){
                newWidth = minWidth
                newKnobLoc.x = newWidth
            }
            
            if(newHeight < minWidth){
                newHeight = minWidth
                newKnobLoc.y = newHeight
            }
            
            
            let maxWidth = propToFloat(prop: 0.8, scaleWithX: true)
            if(newWidth > maxWidth){
                newWidth = maxWidth
                newKnobLoc.x = newWidth
            }
            
            if(newHeight > maxWidth){
                newHeight = maxWidth
                newKnobLoc.y = newHeight
            }
            
            frameChangeKnob.frame = CGRect(origin: newKnobLoc, size: knobPre.size)
            frameChangeKnob.layer.cornerRadius = frameChangeKnob.frame.width/2
            

            bodyView.frame = CGRect(origin: bodyView.frame.origin, size: CGSize(width: newWidth, height: newHeight))
//            print(bodyView.frame)
            
            self.frame.size = CGSize(width: newWidth, height: newHeight)
            
            updateSubViewsWithNewFrame()

            frameChanged()
        }
    }
    
    func updateSubViewsWithNewFrame(){
        let newLeftFrame = CGRect(x: 0, y: 0, width: bodyView.frame.width/2-((middlePropWidth/2)*bodyView.frame.width), height: bodyView.frame.height)
        leftView.frame = newLeftFrame;
        let newRightFrame = CGRect(x: bodyView.frame.width/2+((middlePropWidth/2)*bodyView.frame.width), y: 0, width: bodyView.frame.width/2-((middlePropWidth/2)*bodyView.frame.width), height: bodyView.frame.height)
        rightView.frame = newRightFrame;
        
        backgroundView.frame = bodyView.frame
        
        //TODO
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ColorToUIColor(col : Color) -> UIColor{
        return UIColor(red: col.r, green: col.g, blue: col.b, alpha: col.a)
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
    
    //could have also used a Line type instead of string
    func getStep1(_ lineUUID : String) -> Bool {
        if let states = lineStates[lineUUID] {
            return states.step1
        }
        return false;
    }
    
    
    func setStep1(_ lineUUID: String, to: Bool){
//        let key = lineStates.index(forKey: lineUUID)
        let keyExists = lineStates[lineUUID] != nil
        
        if(keyExists){
            lineStates[lineUUID]?.step1 = to;
        }else{
            let newState = LineState(step1: to, step2: false)
            lineStates[lineUUID] = newState
        }
    }
    
    
    func getStep2(_ lineUUID : String) -> Bool {
        if let states = lineStates[lineUUID] {
            return states.step2
        }
        return false;
    }
    
    
    func setStep2(_ lineUUID: String, to: Bool){
        //        let key = lineStates.index(forKey: lineUUID)
        let keyExists = lineStates[lineUUID] != nil
        
        if(keyExists){
            lineStates[lineUUID]?.step2 = to;
        }else{
            let newState = LineState(step1: false, step2: to)
            lineStates[lineUUID] = newState
        }
    }

}
