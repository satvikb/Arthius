//
//  CreateLevelSelector.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol CreateLevelSelectorViewDelegate: class {
    func createLevelSelect_pressBack()
    func createLevelSelect_createNew()
    func createLevelSelect_pressLevel(level:LevelData)
//    func playSelect_pressSavedLevelsSelect()
}

class CreateLevelSelectView : UIView, LevelSelectorDelegate {
    weak var createLevelSelectDelegate:CreateLevelSelectorViewDelegate?
    var titleLabel : Label!;
    
    
    var levels : [LevelData] = []
    //    var levelTiles : [LevelSelectTile] = []
    
    var levelSelectScroll : LevelSelector!;
    
    var backButton : Button!;
    var createButton : Button!;
    
    init(startPosition: CGPoint){
        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        
        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.5, y: 0.05, width: 0.6, height: 0.15)), text: "Create", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), _inPos: propToPoint(prop: CGPoint(x: 0.3, y: 0.05)), textColor: UIColor.black, valign: .Bottom, _insets: false)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)
        
        backButton = Button(propFrame: CGRect(x: 0, y: 0.05, width: 0.2, height: 0.15), text: "back")
        backButton.pressed = {
            self.createLevelSelectDelegate?.createLevelSelect_pressBack()
        }
        self.addSubview(backButton)
        
        createButton = Button(propFrame: CGRect(x: 0, y: 0.25, width: 1, height: 0.15), text: "New")
        createButton.pressed = {
            self.createLevelSelectDelegate?.createLevelSelect_createNew()
        }
        self.addSubview(createButton)
        
        loadLevels()
    }
    
    func loadLevels(){
        // load all .gws files from campaignlevels directory
        // loading async?
        
        levels = File.getAllLevels(type: .UserMade)
        
        if(levelSelectScroll != nil){
            levelSelectScroll.removeFromSuperview()
        }
        
        //TODO NOT like campaign levels, make them all like the New button, fully horizontal, stacked
        levelSelectScroll = LevelSelector(frame: propToRect(prop: CGRect(x: 0, y: 0.45, width: 1, height: 0.55)), xTiles: 3, yTiles: 3, levels: levels)
        levelSelectScroll.levelSelectorDelegate = self;
        self.addSubview(levelSelectScroll)
    }
    
    func animateIn(time: CGFloat){
        titleLabel.animateIn(time: time)
        backButton.animateIn()
        createButton.animateIn()
        levelSelectScroll.animateIn();
    }
    
    func animateOut(time : CGFloat){
        titleLabel.animateOut(time: time)
        backButton.animateOut()
        createButton.animateOut()
        levelSelectScroll.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func levelSelector_pressedLevel(level: LevelData) {
        self.createLevelSelectDelegate?.createLevelSelect_pressLevel(level: level)
    }
}
