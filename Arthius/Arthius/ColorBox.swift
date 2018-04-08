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
    
    init(frame: CGRect, _rotation: CGFloat, _leftColor : Color, _rightColor : Color, backgroundColor : Color, _middlePropWidth : CGFloat, _stageView : UIView) {
        rotation = _rotation;
        leftColor = _leftColor;
        rightColor = _rightColor;
        middlePropWidth = _middlePropWidth;
        stageView = _stageView;
        
//        print("F \(frame)")
        super.init(frame: frame)//, rotation: rotation, box: box)
        
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = UIColor.clear//ColorBox.ColorToUIColor(col: backgroundColor)

        bodyView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))//, rotation: rotation, box: box)
        
        bodyView.layer.borderWidth = 3;
        bodyView.layer.borderColor = UIColor.black.cgColor
        bodyView.transform = CGAffineTransform(rotationAngle: rotation);

        self.addSubview(bodyView)
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundView.backgroundColor = backgroundColor.uiColor()
        bodyView.addSubview(backgroundView)
        
        //rotation should be handled by parent
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height))
        leftView.backgroundColor = leftColor.uiColor()
//        leftView.transform = CGAffineTransformMakeRotation(rotation);
        bodyView.addSubview(leftView)
        
        rightView = UIView(frame: CGRect(x: frame.width/2+((middlePropWidth/2)*frame.width), y: 0, width: frame.width/2-((middlePropWidth/2)*frame.width), height: frame.height))
//        rightView.transform = CGAffineTransformMakeRotation(rotation);
        rightView.backgroundColor = rightColor.uiColor()
        bodyView.addSubview(rightView)

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
