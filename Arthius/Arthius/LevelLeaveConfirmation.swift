//
//  LevelLeaveConfirmation.swift
//  Arthius
//
//  Created by Satvik Borra on 3/31/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class LevelLeaveConfirmation : UIView {
    
    var confimed = {}
    var denied = {}
    var cancelled = {}
    
    var backgroundView : UIView!;
    var confirmationLabel : Label!;
    var confirmButton : Button!;
    var denyButton : Button!
    var cancelledButton : Button!

    init(frame: CGRect, confirmationText : String) {
        super.init(frame: frame)
    
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        backgroundView = UIView(frame: propToRect(prop: CGRect(x: 0.1, y: 0.4, width: 0.8, height: 0.25), within: self.frame))
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = backgroundView.frame.height/5
        self.addSubview(backgroundView)

        
        //TODO animations, outPos not right
        confirmationLabel = Label(frame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.5), within: backgroundView.frame), text: confirmationText, _outPos: propToRect(prop: CGRect(x: -1, y: 0.4, width: 0, height: 0), within: self.frame).origin, textColor: UIColor.black, valign: VAlign.Default, _insets: false)
        
        backgroundView.addSubview(confirmationLabel)
        
        
        confirmButton = Button(frame: propToRect(prop: CGRect(x: 0.6, y: 0.55, width: 0.3, height: 0.4), within: backgroundView.frame), text: "confirm", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.4, width: 0, height: 0), within: self.frame).origin)
        confirmButton.pressed = {
            self.confimed()
        }
        backgroundView.addSubview(confirmButton)
        
        
        
        denyButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.55, width: 0.3, height: 0.4), within: backgroundView.frame), text: "cancel", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.4, width: 0, height: 0), within: self.frame).origin)
        denyButton.pressed = {
            self.denied()
        }
        backgroundView.addSubview(denyButton)
        
//        cancelledButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.55, width: 0.3, height: 0.4), within: backgroundView.frame), text: "cancel", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.4, width: 0, height: 0), within: self.frame).origin)
//        cancelledButton.pressed = {
//            self.denied()
//        }
//        backgroundView.addSubview(cancelledButton)
        
        
        
    }
    
    func animateIn(){
        confirmButton.animateIn()
        denyButton.animateIn()
    }
    
    func animateOut(){
        confirmButton.animateOut()
        denyButton.animateOut()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelled()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
