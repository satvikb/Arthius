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

class ColorBox :  BaseLevelRectangle {
    
    var leftColor : Color!;
    var rightColor : Color!;
    var middlePropWidth : CGFloat!;
    
    var leftView : UIView!;
    var rightView : UIView!;
    
    var step1 : Bool = false;
    var step2 : Bool = false;
    
    var stageView : UIView;
    
    
    //To edit in level editor
    var editable : Bool! = false;
    var panGesture : UIPanGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
    init(frame: CGRect, rotation: CGFloat, box: Bool, _leftColor : Color, _rightColor : Color, backgroundColor : Color, _middlePropWidth : CGFloat, _stageView : UIView, _editable : Bool = false) {
        leftColor = _leftColor;
        rightColor = _rightColor;
        middlePropWidth = _middlePropWidth;
        stageView = _stageView;
        editable = _editable;
        
        super.init(frame: frame, rotation: rotation, box: box)
        self.backgroundColor = ColorBox.ColorToUIColor(col: backgroundColor)
        
        
        //rotation should be handled by parent
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height))
        leftView.backgroundColor = ColorBox.ColorToUIColor(col: leftColor)
//        leftView.transform = CGAffineTransformMakeRotation(rotation);
        self.addSubview(leftView)
        
        rightView = UIView(frame: CGRect(x: frame.width/2+((middlePropWidth/2)*frame.width), y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height))
//        rightView.transform = CGAffineTransformMakeRotation(rotation);
        rightView.backgroundColor = ColorBox.ColorToUIColor(col: rightColor)
        self.addSubview(rightView)
        
        
        //editable
        if(editable){
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            self.addGestureRecognizer(panGesture)
            
    //        TODO box (done)
            frameChangeKnob = KnobEdit(frame: propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0.4, height: 0.1), within: self.frame))
            frameChangeKnob.panned = {(pan: UIPanGestureRecognizer) in
                //in case
                if(self.editable == true){
                    self.handleFrameChangePan(pan: pan)
                }
            }
            self.addSubview(frameChangeKnob)
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

    func handleFrameChangePan(pan: UIPanGestureRecognizer){

        if pan.state == .began {
            preFrame = self.frame
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            //            self.center = boxCenter // restore button center
        } else {
            let change = pan.translation(in: superview) // get pan location
//            var originOffset = CGPoint.zero;
            
            var newWidth = preFrame.size.width+change.x
            var newHeight = preFrame.size.height+change.y
            
            let minWidth = propToFloat(prop: 0.03, scaleWithX: true)
            if(newWidth < minWidth){
                newWidth = minWidth
            }
            
            if(newHeight < minWidth){
                newHeight = minWidth
            }
            
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: newWidth, height: newHeight))
            updateSubViewsWithNewFrame()

            frameChanged()
        }
    }
    
    func updateSubViewsWithNewFrame(){
        let newLeftFrame = CGRect(x: 0, y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height)
        leftView.frame = newLeftFrame;
        let newRightFrame = CGRect(x: frame.width/2+((middlePropWidth/2)*frame.width), y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height)
        rightView.frame = newRightFrame;
        
        //TODO
        var newKnobFrame : CGRect = propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0.4, height: 0.1), within: self.frame)
        newKnobFrame.size = CGSize(width: newKnobFrame.width, height: newKnobFrame.width)
        frameChangeKnob.frame = newKnobFrame;
        frameChangeKnob.layer.cornerRadius = frameChangeKnob.frame.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ColorToUIColor(col : Color) -> UIColor{
        return UIColor(red: col.r, green: col.g, blue: col.b, alpha: col.a)
    }
    
//    static func UIColorToColor(col : UIColor) -> Color{
//        let components = col.colorComponents!;
//        return Color(r: components.red, g: components.green, b: components.blue, a: components.alpha)
//    }
}
