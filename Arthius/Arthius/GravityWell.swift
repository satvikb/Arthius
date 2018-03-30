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
    
    var corePoint:CGPoint!;
    var coreDiameter : CGFloat!;
    var areaOfEffectDiameter : CGFloat!;
    
    var mass : CGFloat = 100;
    
    var touched = {}
    
    
    
    var editable : Bool! = false;
    var panGesture : UIPanGestureRecognizer!;
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
        
        coreView = UIView(frame: coreFrame)
        coreView.layer.cornerRadius = coreDiameter/2
        
        coreView.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.7)
        self.backgroundColor = UIColor(red: 0, green: 0.2, blue: 1, alpha: 0.4)

        
        self.addSubview(coreView)
        
        //editable
//        if(editable){
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            self.addGestureRecognizer(panGesture)
        
        //TODO Use knob for INNER CORE size, PINCH to change outer size
//            frameChangeKnob = KnobEdit(frame: propToRect(prop: CGRect(x: 0.8, y: 0.8, width: 0.4, height: 0.1), within: self.frame))
//            frameChangeKnob.panned = {(pan: UIPanGestureRecognizer) in
//                //in case
//                if(self.editable == true){
//                    self.handleFrameChangePan(pan: pan)
//                }
//            }
//            if(editable){
//                self.addSubview(frameChangeKnob)
//            }
//        }
        
    }
    
    func updateSize(){
        let frame = CGRect(origin: CGPoint(x: corePoint.x-areaOfEffectDiameter/2, y: corePoint.y-areaOfEffectDiameter/2), size: CGSize(width:areaOfEffectDiameter, height: areaOfEffectDiameter))
        self.frame = frame;
        self.layer.cornerRadius = areaOfEffectDiameter/2;
        
        let coreFrame = CGRect(origin: CGPoint(x: (frame.width/2)-coreDiameter/2, y: (frame.height/2)-coreDiameter/2), size: CGSize(width:coreDiameter, height: coreDiameter))
        coreView.frame = coreFrame;
        coreView.layer.cornerRadius = coreDiameter/2

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
            self.center = CGPoint(x: boxCenter.x+location.x, y: boxCenter.y+location.y)
            frameChanged()
        }
    }
    
    
    var heldDown = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heldDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count > 0){
            if(heldDown == true && touchInBtn(point: touches.first!.location(in: self.superview))){
                heldDown = false
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GravityWell {
    var data : GravityWellData {
        return GravityWellData(position: pointToProp(point: self.corePoint), mass: self.mass, coreDiameter: floatToProp(float: self.coreDiameter, scaleWithX: true), areaOfEffectDiameter: floatToProp(float: self.areaOfEffectDiameter, scaleWithX: true))
    }
}
