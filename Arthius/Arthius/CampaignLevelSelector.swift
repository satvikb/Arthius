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
    
    var levels : [LevelData] = []
    var levelTiles : [CampainLevelSelectTile] = []
    
    var levelSelectScroll : UIScrollView!;
    
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
        
        loadLevels()
    }
    
    func loadLevels(){
        // load all .gws files from campaignlevels directory
        // loading async?
        
        
        levels = File.getAllCampaignLevels()
        
        let xTiles : CGFloat = 3;
        let yTiles : CGFloat = 3;
        
        let sidePadding : CGFloat = 0.05;
        let topPadding : CGFloat = 0.05;

        let xMiddlePadding : CGFloat = 0.02;
        let yMiddlePadding : CGFloat = 0.02;

        let startY : CGFloat = 0.25
//        var startX : CGFloat = 0;
        
        let preDivX : CGFloat = ((xMiddlePadding*(xTiles-1))+(sidePadding*2));
        let tilePropWidth = (1.0-preDivX)/xTiles;
        
        let preDivY : CGFloat = (yMiddlePadding*(yTiles-1))+(topPadding*2);
        let tilePropHeight = ((1-startY)-preDivY)/yTiles;

        var i = 0;
        
        
        levelSelectScroll = UIScrollView(frame: propToRect(prop: CGRect(x: 0, y: startY-yMiddlePadding, width: 1, height: 1-(startY-yMiddlePadding))))
        levelSelectScroll.showsVerticalScrollIndicator = false;
        levelSelectScroll.showsHorizontalScrollIndicator = false;
        levelSelectScroll.isUserInteractionEnabled = true;
        
        for level in levels {
            let x = CGFloat(Int((i%Int(xTiles))));
            let y :CGFloat = CGFloat(Int(CGFloat(i)/yTiles))//-1;
            
            let propRect = CGRect(x: startX+sidePadding+(tilePropWidth*x)+(xMiddlePadding*x), y: /*startY*/+topPadding+(tilePropHeight*y)+(yMiddlePadding*y), width: tilePropWidth, height: tilePropHeight);
            let levelTile = CampainLevelSelectTile(frame: propToRect(prop: propRect), _level: level)
            levelTile.backgroundColor = UIColor.yellow
            
            levelTile.pressed = {(levelData : LevelData) in
                self.campaignLevelSelectDelegate?.campaignLevelSelect_pressLevel(level: levelData)
            }
            
            levelSelectScroll.addSubview(levelTile)
            i += 1;
            
            
//            if(i == Int(xTiles*yTiles)){
//                //start next page
//                startX += 1;
//            }
        }
        
        levelSelectScroll.contentSize = propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1-(startY-yMiddlePadding))).size
        
        self.addSubview(levelSelectScroll)
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



class CampainLevelSelectTile : UIView {
    
    var level : LevelData
    var pressed = {(levelData : LevelData) in
        
    }
    
    var heldDown : Bool = false;
    
    init(frame: CGRect, _level: LevelData){
        level = _level;
        
        super.init(frame: frame);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heldDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //            print("end \(touches.count) \(heldDown) \(touchInBtn(point: (touches.first?.location(in: self.superview))!))")
        if(touches.count > 0){
            if(heldDown == true && touchInBtn(point: touches.first!.location(in: self.superview))){
                heldDown = false
                pressed(level)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
