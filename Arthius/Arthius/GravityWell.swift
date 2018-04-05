//
//  GravityWell.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class GravityWell: UIView {
    
    var coreView : UIView!;
    var coreOuterLayer : CAShapeLayer!;
    
    var corePoint:CGPoint!;
    var coreDiameter : CGFloat!;
    var areaOfEffectDiameter : CGFloat!;
    
    var mass : CGFloat = 100;
    
    var touched = {}
    
    
    
    var editable : Bool! = false;
    var panGesture : UIPanGestureRecognizer!;
    var pinchGesture : UIPinchGestureRecognizer!;
    var frameChanged = {}
    var frameChangeKnob : KnobEdit!;
    
    
    
    init(corePoint: CGPoint, coreDiameter: CGFloat, areaOfEffectDiameter: CGFloat, mass: CGFloat) {
        self.corePoint = corePoint;
        self.coreDiameter = coreDiameter;
        self.areaOfEffectDiameter = areaOfEffectDiameter;
        self.mass = mass;
        
        let frame = CGRect(origin: CGPoint(x: corePoint.x-areaOfEffectDiameter/2, y: corePoint.y-areaOfEffectDiameter/2), size: CGSize(width:areaOfEffectDiameter, height: areaOfEffectDiameter))
        let coreFrame = CGRect(origin: CGPoint(x: (frame.width/2)-coreDiameter/2, y: (frame.height/2)-coreDiameter/2), size: CGSize(width:coreDiameter, height: coreDiameter))

        super.init(frame: frame)
        
        self.layer.cornerRadius = areaOfEffectDiameter/2;
        self.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.4)

        coreView = UIView(frame: coreFrame)
        coreView.layer.cornerRadius = coreDiameter/2
        
        coreView.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.7)
        self.addSubview(coreView)
        
        
        
        coreOuterLayer = CAShapeLayer()
        coreOuterLayer.fillColor = UIColor.yellow.cgColor
        coreOuterLayer.strokeColor = UIColor.black.cgColor
//        coreOuterLayer.frame = CGRect(origin: CGPoint.zero, size: frame.size)

        self.updateCorePath()
//        self.layer.addSublayer(coreOuterLayer)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delaysTouchesBegan = false
        self.addGestureRecognizer(panGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        
    }
    
    func updateCorePath(){
        func getCorePath() -> UIBezierPath{
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: coreView.frame.midX,y: coreView.frame.midY), radius: coreDiameter/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

            return circlePath
        }
        
        coreOuterLayer.path = getCorePath().cgPath
        coreOuterLayer.lineWidth = coreView.frame.width*0.2
        coreOuterLayer.bounds = coreOuterLayer.path!.boundingBox// IMPORTANT, without this hitTest wont work

    }
    
    func updateSize(){
        let frame = CGRect(origin: CGPoint(x: corePoint.x-areaOfEffectDiameter/2, y: corePoint.y-areaOfEffectDiameter/2), size: CGSize(width:areaOfEffectDiameter, height: areaOfEffectDiameter))
        self.frame = frame;
        self.layer.cornerRadius = areaOfEffectDiameter/2;
        
        let coreFrame = CGRect(origin: CGPoint(x: (frame.width/2)-coreDiameter/2, y: (frame.height/2)-coreDiameter/2), size: CGSize(width:coreDiameter, height: coreDiameter))
        coreView.frame = coreFrame;
        coreView.layer.cornerRadius = coreDiameter/2

        updateCorePath()
        //TODO
        //change mass proportional to diameter
    }

    var boxCenter = CGPoint.zero
    
    @objc func handlePan(_ pan : UIPanGestureRecognizer){
        if pan.state == .began {
            boxCenter = self.center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {

        } else {
            let location = pan.translation(in: superview) // get pan location
            let newCenter = CGPoint(x: boxCenter.x+location.x, y: boxCenter.y+location.y)
            self.center = newCenter
            self.corePoint = newCenter;
            frameChanged()
        }
    }
    
    @objc func handlePinch(_ pinch : UIPinchGestureRecognizer){
//        if pan.state == .began {
//            boxCenter = self.center // store old button center
//        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
//
//        } else {
//            let location = pan.translation(in: superview) // get pan location
//            self.center = CGPoint(x: boxCenter.x+location.x, y: boxCenter.y+location.y)
//            frameChanged()
//        }
        bringToFront()
        
        var currentOuterSize = areaOfEffectDiameter
        currentOuterSize = currentOuterSize! * pinch.scale
        coreDiameter = coreDiameter! * pinch.scale
        print(pinch.scale, currentOuterSize!, areaOfEffectDiameter)
        areaOfEffectDiameter = currentOuterSize
        updateSize()
        
        pinch.scale = 1
    }
    
    
    var heldDown = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heldDown = true;
        
        
//        
//        let point = touches.first?.location(in: self) // Where you pressed
//        let np = self.coreOuterLayer.convert(point!, from: self.layer)
//        
//        print("d \(self.coreOuterLayer.hitTest(np)) \(np)")
//        if let layer = self.coreOuterLayer.hitTest(point!) as? CAShapeLayer { // If you hit a layer and if its a Shapelayer
//            if (layer.path?.contains(point!))! { // Optional, if you are inside its content path
//                print("Hit shapeLayer") // Do something
//            }
//        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count > 0){
            if(heldDown == true && touchInBtn(point: touches.first!.location(in: self.superview))){
                heldDown = false
                //TESTING
                touched()
            }
        }
    }
    
    func touchInBtn(point : CGPoint) -> Bool{
        let f = self.frame
        
        if(point.x > f.origin.x && point.x < f.origin.x+f.size.width && point.y > f.origin.y && point.y < f.origin.y+f.size.height){
            return true
        }
        return false
    }
    
    func bringToFront(){
        if(superview != nil){
            self.superview!.bringSubview(toFront: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GravityWell {
    var data : GravityWellData {
        return GravityWellData(position: pointToProp(point: self.corePoint), mass: self.mass, coreDiameter: floatToProp(float: self.coreDiameter, scaleWithX: true), areaOfEffectDiameter: floatToProp(float: self.areaOfEffectDiameter, scaleWithX: true))
    }
}
