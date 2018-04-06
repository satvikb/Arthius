//
//  LevelSelector.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol LevelSelectorDelegate: class {
    func levelSelector_pressedLevel(level: LevelData)
    func getThumbnail(levelUUID: String, completion: @escaping (_ img : UIImage) -> Void);
}

//used in create level selector and campaign level selector
class LevelSelector : UIScrollView {
    
    weak var levelSelectorDelegate:LevelSelectorDelegate?
    var levels : [LevelData]!
    var xTiles : CGFloat!
    var yTiles : CGFloat!
    
    init(frame: CGRect, xTiles: CGFloat, yTiles : CGFloat, levels : [LevelData]){
        super.init(frame: frame)
        
        self.levels = levels
        self.xTiles = xTiles
        self.yTiles = yTiles
        
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.isUserInteractionEnabled = true;
        
        self.updateLevels(xTiles, yTiles, newLevels: levels)
        
    }
    
    func updateLevels(_ newXTiles : CGFloat, _ newYTiles : CGFloat, newLevels : [LevelData]){
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
        xTiles = newXTiles
        yTiles = newYTiles
        levels = newLevels;
        
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
        for level in levels {
            let x = CGFloat(Int((i%Int(xTiles))));
            let y :CGFloat = CGFloat(Int(CGFloat(i)/yTiles))//-1;
            
            let propRect = CGRect(x: startX+sidePadding+(tilePropWidth*x)+(xMiddlePadding*x), y: /*startY*/+topPadding+(tilePropHeight*y)+(yMiddlePadding*y), width: tilePropWidth, height: tilePropHeight);
            let levelTile = LevelSelectTile(frame: propToRectSelf(prop: propRect), _level: level)
            levelTile.backgroundColor = UIColor.yellow
            
            levelTile.pressed = {(levelData : LevelData) in
                //                self.campaignLevelSelectDelegate?.campaignLevelSelect_pressLevel(level: levelData)
                self.levelSelectorDelegate?.levelSelector_pressedLevel(level: levelData)
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

class LevelSelectTile : UIImageView {
    var level : LevelData
    var pressed = {(levelData : LevelData) in}
    
    var heldDown : Bool = false;
    
    init(frame: CGRect, _level: LevelData){
        level = _level;
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
