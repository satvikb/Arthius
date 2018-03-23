//
//  PlaySelect.swift
//  Arthius
//
//  Created by Satvik Borra on 3/23/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol PlaySelectViewDelegate: class {
    func playSelect_pressBack()
    func playSelect_pressCampaign()
    func playSelect_pressGlobalLevelSelect()
    func playSelect_pressSavedLevelsSelect()
}

class PlaySelectView: UIView {
    
    weak var playSelectDelegate:PlaySelectViewDelegate?
    var titleLabel : Label!;

    var campaignButton : Button!;
    var globalLevelSelectButton : Button!;
    var savedLevelsSelectButton : Button!;

    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        
        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.5, y: 0.05, width: 0.4, height: 0.15)), text: "Play", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), _inPos: propToPoint(prop: CGPoint(x: 0.5, y: 0.05)), textColor: UIColor.black, valign: .Bottom)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)

        let button = Button(propFrame: CGRect(x: 0, y: 0.05, width: 0.2, height: 0.15), text: "back")
        button.pressed = {
            self.playSelectDelegate?.playSelect_pressBack()
        }
        self.addSubview(button)

        
        campaignButton = Button(propFrame: CGRect(x: 0.1, y: 0.25, width: 0.8, height: 0.15), text: "Campaign", fontSize: 60)
        campaignButton.text.textAlignment = .left;
        campaignButton.pressed = {
            self.playSelectDelegate?.playSelect_pressCampaign()
        }
        
        self.addSubview(campaignButton)
        
        
        globalLevelSelectButton = Button(propFrame: CGRect(x: 0.1, y: 0.45, width: 0.8, height: 0.25), text: "Global\nLevel\nSelect", fontSize: 60)
        globalLevelSelectButton.text.numberOfLines = 3;
        globalLevelSelectButton.text.textAlignment = .left;
        globalLevelSelectButton.pressed = {
            self.playSelectDelegate?.playSelect_pressGlobalLevelSelect()
        }
        
        self.addSubview(globalLevelSelectButton)
        
        
        savedLevelsSelectButton = Button(propFrame: CGRect(x: 0.1, y: 0.75, width: 0.8, height: 0.15), text: "Saved Levels", fontSize: 60)
        savedLevelsSelectButton.text.textAlignment = .left;
        savedLevelsSelectButton.pressed = {
            self.playSelectDelegate?.playSelect_pressSavedLevelsSelect()
        }
        
        self.addSubview(savedLevelsSelectButton)
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

