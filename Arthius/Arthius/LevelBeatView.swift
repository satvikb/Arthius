//
//  LevelBeatView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

struct LevelGameplayStats {
    var lineDistance : CGFloat;
    var timePlayed : CGFloat;
}

class LevelBeatView : UIView {
    
    //overlay
    var gameplayStats : LevelGameplayStats!;
    var overlayView : UIView!;
    
    var homeBtn : Button!;
    var nextLevelBtn : Button!;
    
    var homePressed = {}
    var nextLevelPressed = {}
    
    
    //TODO: If custom level, either allow chaging buttons with parameters or some other way make the right btn a share btn
    init(frame: CGRect, _gameplayStats : LevelGameplayStats) {
        gameplayStats = _gameplayStats
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
      
        overlayView = UIView(frame: Screen.propToRect(prop: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8), within: frame))
        overlayView.layer.cornerRadius = overlayView.frame.width*0.1;
        overlayView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.addSubview(overlayView)
        
        homeBtn = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.8, width: 0.2, height: 0.2), within: overlayView.frame), text: "home", fontSize: Screen.fontSize(propFontSize: 10), outPos: propToPoint(prop: CGPoint(x: -1, y: 0)))
        homeBtn.pressed = {
            self.homePressed()
        }
        overlayView.addSubview(homeBtn)
        
        nextLevelBtn = Button(frame: propToRect(prop: CGRect(x: 0.6, y: 0.8, width: 0.2, height: 0.2), within: overlayView.frame), text: "next", fontSize: Screen.fontSize(propFontSize: 10), outPos: propToPoint(prop: CGPoint(x: -1, y: 0)))
        nextLevelBtn.pressed = {
            self.nextLevelPressed()
        }
        overlayView.addSubview(nextLevelBtn)
    }
    
    func animateIn(){
        homeBtn.animateIn()
        nextLevelBtn.animateIn()
    }
    
    func animateOut(){
        homeBtn.animateIn()
        nextLevelBtn.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
