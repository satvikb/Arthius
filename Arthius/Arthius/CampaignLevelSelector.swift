//
//  LevelSelector.swift
//  Arthius
//
//  Created by Satvik Borra on 3/22/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol CampaignLevelSelectorViewDelegate: class {
    func campaignLevelSelect_pressBack()
    func campaignLevelSelect_pressLevel(level:LevelData)
}

class CampaignLevelSelectView: UIView {
    
    weak var campaignLevelSelectDelegate:CampaignLevelSelectorViewDelegate?
    var titleLabel : Label!;
    
    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        
        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.5, y: 0.05, width: 0.6, height: 0.15)), text: "Campaign", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), _inPos: propToPoint(prop: CGPoint(x: 0.3, y: 0.05)), textColor: UIColor.black, valign: .Bottom)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)
        
        let button = Button(propFrame: CGRect(x: 0, y: 0.05, width: 0.2, height: 0.15), text: "back")
        button.pressed = {
            self.campaignLevelSelectDelegate?.campaignLevelSelect_pressBack()
        }
        self.addSubview(button)
        
    }
    
    func loadLevels(){
        //load all .gws files from campaignlevels directory
        // loading async?
    }
    
    func animateIn(time: CGFloat){
        titleLabel.animateIn(time: time)
        
    }
    
    func animateOut(time : CGFloat){
        titleLabel.animateOut(time: time)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
