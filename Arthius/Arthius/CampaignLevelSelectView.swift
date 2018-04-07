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
    func campaignLevelSelect_getThumbnail(uuid : String, completion: @escaping (_ img : UIImage) -> Void)
}

class CampaignLevelSelectView: UIView, CampaignLevelSelectorDelegate {
    
    weak var campaignLevelSelectDelegate:CampaignLevelSelectorViewDelegate?
    var titleLabel : Label!;
    
    var levelSelectScroll : CampaignLevelSelector!;
    
    var backButton : Button!;
    
    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        self.isUserInteractionEnabled = true;
        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.25, y: 0.05, width: 0.65, height: 0.15)), text: "Campaign", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), textColor: UIColor.black, valign: .Bottom, _insets: false)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)
        
        backButton = Button(frame: propToRect(prop: CGRect(x: 0, y: 0.05, width: 0.2, height: 0.15)), text: "back")
        backButton.pressed = {
            self.campaignLevelSelectDelegate?.campaignLevelSelect_pressBack()
        }
        self.addSubview(backButton)
        
        loadLevels()
    }
    
    func loadLevels(){
        // load all .gws files from campaignlevels directory
        // loading async?
        
        levelSelectScroll = CampaignLevelSelector(frame: propToRect(prop: CGRect(x: 0, y: 0.25, width: 1, height: 0.75)), xTiles: 3, yTiles: 3)
        levelSelectScroll.isUserInteractionEnabled = true;
        levelSelectScroll.campaignLevelSelectorDelegate = self
        self.addSubview(levelSelectScroll)
    }
    
    func animateIn(time: CGFloat){
        titleLabel.animateIn(time: time)
        backButton.animateIn()
        
        levelSelectScroll.updateLevels(levelSelectScroll.xTiles, levelSelectScroll.yTiles)
    }
    
    func animateOut(time : CGFloat){
        titleLabel.animateOut(time: time)
        backButton.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func campaignLevelSelector_pressedLevel(level: LevelData) {
        self.campaignLevelSelectDelegate?.campaignLevelSelect_pressLevel(level: level)
    }
    
    func getThumbnail(levelUUID: String, completion: @escaping (UIImage) -> Void) {
        campaignLevelSelectDelegate?.campaignLevelSelect_getThumbnail(uuid: levelUUID, completion: completion)
    }
}
