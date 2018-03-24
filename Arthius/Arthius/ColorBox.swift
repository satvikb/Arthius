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

//enum CurrentLineState {
//    case OutOfLine
//    case InOneSide
//    case InOtherSide
//    case ExitedLine
//    case ColorSwitched
//}

class ColorBox :  BaseLevelRectangle {
    
    var leftColor : Color!;
    var rightColor : Color!;
    var middlePropWidth : CGFloat!;
    
    var leftView : UIView!;
    var rightView : UIView!;
    
//    var lineEnterLeft = {}
//    var lineEnterRight = {}
    
    
    var step1 : Bool = false;
    var step2 : Bool = false;
//    var allowColorChange : Bool = true;
    
    var stageView : UIView;
    
    init(frame: CGRect, rotation: CGFloat, box: Bool, _leftColor : Color, _rightColor : Color, backgroundColor : Color, _middlePropWidth : CGFloat, _stageView : UIView) {
        leftColor = _leftColor;
        rightColor = _rightColor;
        middlePropWidth = _middlePropWidth;
        stageView = _stageView;
        
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
    
    static func ColorToUIColor(col : Color) -> UIColor{
        return UIColor(red: col.r, green: col.g, blue: col.b, alpha: col.a)
    }
    
    static func UIColorToColor(col : UIColor) -> Color{
        let components = col.colorComponents!;
        return Color(r: components.red, g: components.green, b: components.blue, a: components.alpha)
    }
}
