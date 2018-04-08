//
//  EditableColorBox.swift
//  Arthius
//
//  Created by Satvik Borra on 4/8/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

import UIKit

class EditableColorBox :  EditableElement, UIGestureRecognizerDelegate {
    
    var maxSize : CGSize!
    
    var leftColor : Color!;
    var rightColor : Color!;
    var middlePropWidth : CGFloat!;
    
    var bodyView : UIView!//BaseLevelRectangle!;
    
    var backgroundView : UIView!;
    var leftView : UIView!;
    var rightView : UIView!;
    
    var stageView : UIView;
    
    var rotation : CGFloat = 0
    
    var panGesture : UIPanGestureRecognizer!;
    var pinchGesture : UIPinchGestureRecognizer!;
    var rotationGesture : UIRotationGestureRecognizer!;
    
    var frameChanged = {}
    
    init(frame: CGRect, _rotation: CGFloat, _leftColor : Color, _rightColor : Color, backgroundColor : Color, _middlePropWidth : CGFloat, _stageView : UIView) {
        rotation = _rotation;
        leftColor = _leftColor;
        rightColor = _rightColor;
        middlePropWidth = _middlePropWidth;
        stageView = _stageView;
        
//        CGRect(x: 0.45, y: 0.45, width: 0.1, height: 0.1).rect
        maxSize = Screen.propToRect(prop: CGRect(x: 0, y: 0, width: 0.1, height: 0.1)).size
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
        
        
        //editable
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
//        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        pinchGesture.delegate = self
//        self.addGestureRecognizer(pinchGesture)
        
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        rotationGesture.delegate = self
        bodyView.addGestureRecognizer(rotationGesture)
    }
    
    func changeFocus(_ focussed: Bool){
        if(focussed){
            bodyView.layer.borderWidth = 3;
            bodyView.layer.borderColor = UIColor.orange.cgColor
        }else{
            bodyView.layer.borderWidth = 0;
            bodyView.layer.borderColor = UIColor.clear.cgColor
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
    
    var lastScale : CGFloat = 1
    
    let maxScale : CGFloat = 2;
    let minScale : CGFloat = 0.9;
    
    @objc func handlePinch(_ pinch : UIPinchGestureRecognizer){
        if pinch.state == .began {
            lastScale = pinch.scale // store old button center
        }
        
        if pinch.state == .began || pinch.state == .changed {
            let currentScale : CGFloat = pinch.view?.layer.value(forKeyPath: "transform.scale") as! CGFloat
            
            var newScale : CGFloat = 1 - (lastScale - pinch.scale)
            newScale = min(newScale, maxScale / currentScale)
            newScale = max(newScale, minScale / currentScale)
            
            let trans = pinch.view?.transform.scaledBy(x: newScale, y: newScale)
            pinch.view?.transform = trans!
            lastScale = pinch.scale
            
            frameChanged()
        }
    }
    
    
    @objc func handleRotation(_ rotationGR : UIRotationGestureRecognizer){
        
        self.superview!.bringSubview(toFront: self)
        
        let rotation = rotationGR.rotation
        rotationGR.view?.transform = (rotationGR.view?.transform.rotated(by: rotation))!
        rotationGR.rotation = 0.0
        let radians: CGFloat = atan2( (rotationGR.view?.transform.b)!, (rotationGR.view?.transform.a)!)
        
        self.rotation = radians
        frameChanged()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        recievedTouch()
        return true
    }
    
    func updateSubViewsWithNewFrame(){
        let newLeftFrame = CGRect(x: 0, y: 0, width: bodyView.frame.width/2-((middlePropWidth/2)*bodyView.frame.width), height: bodyView.frame.height)
        leftView.frame = newLeftFrame;
        let newRightFrame = CGRect(x: bodyView.frame.width/2+((middlePropWidth/2)*bodyView.frame.width), y: 0, width: bodyView.frame.width/2-((middlePropWidth/2)*bodyView.frame.width), height: bodyView.frame.height)
        rightView.frame = newRightFrame;
        
        backgroundView.frame = bodyView.frame
    }
    
    func getData() -> ColorBoxData{
        return ColorBoxData(frame: self.frame.rect, rotation: Float32(rotation), leftColor: leftColor, rightColor: rightColor, backgroundColor: backgroundColor?.color, middlePropWidth: Float32(middlePropWidth))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
