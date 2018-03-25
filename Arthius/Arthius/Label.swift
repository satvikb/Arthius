//
//  Label.swift
//  AlphabetOrder
//
//  Created by Satvik Borra on 12/20/16.
//  Copyright © 2016 vborra. All rights reserved.
//

import UIKit

enum VAlign {
    case Top
    case Default
    case Bottom
}

class Label: UILabel{
    
    static let Null = Label(frame: CGRect.zero, text: "")
    
    var outPos: CGPoint!
    var inPos: CGPoint!
    
    var vAlign: VAlign = .Default;
    var insets: Bool = false;
    
    //TODO for Label and Button, _outPos: take into account withinFrame
    init(frame: CGRect, text: String, _outPos: CGPoint = Screen.propToPoint(prop: CGPoint(x: -1, y: 0)), textColor: UIColor = UIColor.white, valign : VAlign = .Default, _insets: Bool = true){
        outPos = _outPos
        inPos = frame.origin;
        vAlign = valign;
        insets = _insets;
        
        let newFrame = CGRect(origin: outPos, size: frame.size)
        super.init(frame: newFrame)
        
        adjustsFontSizeToFitWidth = true
           
//        self.layer.borderColor = UIColor.black.cgColor;
//        self.layer.borderWidth = 3;
        
        changeTextColor(color: textColor)
        self.text = text
    }
    
    func changeTextColor(color: UIColor){
        textColor = color
    }
    
    
    override func drawText(in r: CGRect) {
//        CGFloat height = [self sizeThatFits:rect.size].height;
        var rect = r;

        if(vAlign == .Top){
            rect.size.height = self.sizeThatFits(rect.size).height
        }else if(vAlign == .Bottom){
            let height = self.sizeThatFits(rect.size).height
            rect.origin.y += rect.size.height - height;
            rect.size.height = height;
        }
        
        var theInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        if(insets == true){
            theInsets = UIEdgeInsets(top: 0, left: r.width*0.1, bottom: 0, right: r.width*0.1)
        }
        super.drawText(in: UIEdgeInsetsInsetRect(rect, theInsets))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn(time: CGFloat = transitionTime){
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.frame.origin = self.inPos
        })
    }
    
    func animateOut(time: CGFloat = transitionTime){
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.frame.origin = self.outPos
        })
    }
    
}
