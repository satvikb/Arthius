//
//  CampaignLevelSelector.swift
//  Arthius
//
//  Created by Satvik Borra on 4/6/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol CampaignLevelSelectorDelegate: class {
    func campaignLevelSelector_pressedLevel(level: LevelData)
    func getThumbnail(levelUUID: String, completion: @escaping (_ img : UIImage) -> Void);
}

//used in create level selector and campaign level selector
class CampaignLevelSelector : UIScrollView {
    
    weak var campaignLevelSelectorDelegate:CampaignLevelSelectorDelegate?
    var xTiles : CGFloat!
    var yTiles : CGFloat!
    
    init(frame: CGRect, xTiles: CGFloat, yTiles : CGFloat){
        super.init(frame: frame)
        
        self.xTiles = xTiles
        self.yTiles = yTiles
        
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.isUserInteractionEnabled = true;
        
        self.updateLevels(xTiles, yTiles)
        
    }
    
    func updateLevels(_ newXTiles : CGFloat, _ newYTiles : CGFloat){
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
        xTiles = newXTiles
        yTiles = newYTiles
        
        let sidePadding : CGFloat = 0.05;
        let topPadding : CGFloat = 0.05;
        
        let xMiddlePadding : CGFloat = 0.02;
        let yMiddlePadding : CGFloat = 0.02;
        
        let startX : CGFloat = 0;
        
        let preDivX : CGFloat = ((xMiddlePadding*(xTiles-1))+(sidePadding*2));
        let tilePropWidth = (1.0-preDivX)/xTiles;
        
        let preDivY : CGFloat = (yMiddlePadding*(yTiles-1))+(topPadding*2);
        let tilePropHeight = ((1)-preDivY)/yTiles;
        
        var i = 0
        for level in CampaignLevelHandler.allLevels {
//            var progress = CampaignProgressHandler.progress.progress[Int((level.levelMetadata?.levelNumber)!)]
            var progress = ProgressHandler.getCurrentProgressForUUID(uuid: (level.levelMetadata?.levelUUID)!);
            if progress == nil{
                progress = LevelProgressData(uuid: level.levelMetadata?.levelUUID, completed: false, locked: true, stars: 0, time: 0, distance: 0);
                
                //dont actually save new progress
//                progress = ProgressHandler.setProgress(<#T##progress: LevelProgressData##LevelProgressData#>)
//                progress = CampaignProgressHandler.setProgress(Int((level.levelMetadata!.levelNumber)), CampaignProgressData(levelNumber: Int(level.levelMetadata!.levelNumber), completed: false, locked: true, stars: 0, time: 0, distance: 0))
            }
            
            
            let x = CGFloat(Int((i%Int(xTiles))));
            let y :CGFloat = CGFloat(Int(CGFloat(i)/yTiles))//-1;
            
            let propRect = CGRect(x: startX+sidePadding+(tilePropWidth*x)+(xMiddlePadding*x), y: /*startY*/+topPadding+(tilePropHeight*y)+(yMiddlePadding*y), width: tilePropWidth, height: tilePropHeight);
            let levelTile = CampaignLevelSelectTile(frame: propToRectSelf(prop: propRect), _level: level, _progressData: progress!)
            
            if(progress!.locked){
                levelTile.backgroundColor = UIColor.yellow
            }else{
                levelTile.layer.borderColor = UIColor.black.cgColor
                levelTile.layer.borderWidth = 3
            }
            
            levelTile.pressed = {(levelData : LevelData) in
                //                self.campaignLevelSelectDelegate?.campaignLevelSelect_pressLevel(level: levelData)
                if(!progress!.locked){
                    self.campaignLevelSelectorDelegate?.campaignLevelSelector_pressedLevel(level: levelData)
                }
            }
            
            self.addSubview(levelTile)
            i += 1;
        }
        
        self.contentSize = propToRectSelf(prop: CGRect(x: 0, y: 0, width: 1, height: 1)).size
    }
    
    func propToRectSelf(prop: CGRect) -> CGRect {
        let screen = self.bounds
        return CGRect(x: prop.origin.x * screen.width, y: prop.origin.y * screen.height, width: screen.width*prop.width, height: screen.height*prop.height)
    }
    
    //TODO Animate
    func animateIn(){
        
    }
    
    func animateOut(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CampaignLevelSelectTile : UIImageView {
    var level : LevelData
    var progressData : LevelProgressData
    
    var pressed = {(levelData : LevelData) in}
    
    var heldDown : Bool = false;
    
    init(frame: CGRect, _level: LevelData, _progressData: LevelProgressData){
        level = _level;
        progressData = _progressData
        
        super.init(frame: frame);
        self.isUserInteractionEnabled = true;
        self.contentMode = UIViewContentMode.scaleAspectFit;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heldDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
