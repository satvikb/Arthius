//
//  BoxButton.swift
//  versal
//
//  Created by Satvik Borra on 5/27/17.
//  Copyright © 2017 sborra. All rights reserved.
//

import UIKit

class Button : UIView{
    
//    var backgroundView : UIView!;
    
    var heldDownFrame : CGRect!;
    var heldUpFrame : CGRect!;
    
    var text : Label!;

    var inPos : CGPoint;
    var outPos : CGPoint;
    
    init(propFrame: CGRect, text: String = "", fontSize: CGFloat = 20, outPos : CGPoint = Screen.propToPoint(prop: CGPoint(x: -1, y: 0))){
//        let viewOffsetX : CGFloat = Screen.propToFloat(prop: -propFrame.width/20, scaleWithX: false)
//        let viewOffsetY : CGFloat = Screen.y(p: -propWidth/20) //-0.01
        let frame : CGRect = Screen.propToRect(prop: propFrame)
        
        self.inPos = frame.origin
        self.outPos = outPos;

        super.init(frame: CGRect(origin: outPos, size: frame.size))
        self.backgroundColor = UIColor.gray
        
        self.text = Label(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), text: text)
        self.text.textAlignment = .center
        self.text.font = UIFont(name: "SFProText-Light", size: Screen.fontSize(propFontSize: fontSize))
        self.text.changeTextColor(color: UIColor.white)
        
        self.addSubview(self.text)
//        heldDownFrame = Screen.propToRect(prop:propFrame)
//        heldUpFrame = Screen.propToRect(prop: propFrame).offsetBy(dx: viewOffsetX, dy: viewOffsetX)
//
//        pressView = ButtonPressView(heldDownFrame: heldDownFrame, heldUpFrame: heldUpFrame, text: text)
//        pressView.touchDown = {
//            self.pressView.frame = self.heldDownFrame
//        }
//
//        pressView.touchUp = {
//            self.moveUp()
//            self.rawPressed()
//        }
//
//        pressView.touchMoveOutside = {
//            self.moveUp()
//        }
        
//        backgroundView = UIView(frame: )
//        backgroundView.backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rawPressed(){
        pressed()
    }
    
    var pressed = {}
    
    func animateOut(){
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.frame.origin = self.outPos
        })
    }

    func animateIn(){
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.frame.origin = self.inPos
        })
    }
    var heldDown = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heldDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //            print("end \(touches.count) \(heldDown) \(touchInBtn(point: (touches.first?.location(in: self.superview))!))")
        if(touches.count > 0){
            if(heldDown == true && touchInBtn(point: touches.first!.location(in: self.superview))){
                heldDown = false
                rawPressed()
            }
        }
    }
    
    func touchInBtn(point : CGPoint) -> Bool{
        let f = self.frame//heldDown == true ? heldDownFrame! : heldUpFrame!
        
        if(point.x > f.origin.x && point.x < f.origin.x+f.size.width && point.y > f.origin.y && point.y < f.origin.y+f.size.height){
            return true
        }
        return false
    }
    
}
