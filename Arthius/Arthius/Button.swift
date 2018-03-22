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
    
    var text : UILabel!;

    init(propFrame: CGRect, text: String = ""){
//        let viewOffsetX : CGFloat = Screen.propToFloat(prop: -propFrame.width/20, scaleWithX: false)
//        let viewOffsetY : CGFloat = Screen.y(p: -propWidth/20) //-0.01
        
        super.init(frame: Screen.propToRect(prop: propFrame))
        self.backgroundColor = UIColor.gray
        
        
        self.text = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.text.textAlignment = .center
        //            self.text.font = UIFont(name: "IowanOldStyle-Roman", size: Screen.fontSize(fontSize: 30))
        
        
        self.text.text = text
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
//        pressUp()
        print("PRESS")
        pressed()
    }
    
    var pressed = {}
    
//    func animateOut(){
//        UIView.animate(withDuration: transitionTime, animations: {
//            self.pressView.frame.origin = Screen.outPos
//            self.backgroundView.frame.origin = Screen.outPos
//        })
//    }
//
//    func animateIn(){
//        UIView.animate(withDuration: transitionTime, animations: {
//            self.pressView.frame.origin = self.heldUpFrame.origin
//            self.backgroundView.frame.origin = self.heldDownFrame.origin
//        })
//    }
    var heldDown = false
//    var touchDown = {}
//    var touchUp = {}
//    var touchMoveOutside = {}
    
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
