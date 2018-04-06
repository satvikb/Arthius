//
//  GLSLevelSelector.swift
//  Arthius
//
//  Created by Satvik Borra on 4/5/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit


protocol GLSSelectorDelegate: class {
    func globalLevelSelector_pressedPlayLevel(level: GLSLevelData)
    func getThumbnail(levelUUID: String, completion: @escaping (_ img : UIImage) -> Void);
}

//used in gls level selector
class GLSLevelSelector : UIScrollView {
    
    weak var glsSelectorDelegate:GLSSelectorDelegate?
    var levels : [GLSLevelData]!
    var xTiles : CGFloat!
    var yTiles : CGFloat!
    
    init(frame: CGRect, xTiles: CGFloat, yTiles : CGFloat, levels : [GLSLevelData]){
        super.init(frame: frame)
        
        self.levels = levels
        self.xTiles = xTiles
        self.yTiles = yTiles
        
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.isUserInteractionEnabled = true;
        
        self.updateLevels(xTiles, yTiles, newLevels: levels)
        
    }
    
    func updateLevels(_ newXTiles : CGFloat, _ newYTiles : CGFloat, newLevels : [GLSLevelData]){
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
            let levelTile = GLSSelectTile(frame: propToRectSelf(prop: propRect), _level: level)
            levelTile.backgroundColor = UIColor.yellow
            
            glsSelectorDelegate?.getThumbnail(levelUUID: level.levelUUID, completion: {(img : UIImage) in
                levelTile.image = img
            })
            
            
            levelTile.pressed = {(levelData : GLSLevelData) in
                self.showLevelDetailView(levelTile: levelTile)
//                self.glsSelectorDelegate?.levelSelector_pressedLevel(level: levelData)
            }
            
            self.addSubview(levelTile)
            i += 1;
        }
        
        self.contentSize = propToRectSelf(prop: CGRect(x: 0, y: 0, width: 1, height: 1)).size
    }
    
    func showLevelDetailView(levelTile : GLSSelectTile){
        let detailView : GLSLevelDetailView = GLSLevelDetailView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), tileView: levelTile);
        self.addSubview(detailView)
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

class GLSSelectTile : UIImageView {
    var level : GLSLevelData
    var pressed = {(glsData : GLSLevelData) in}
    
    var heldDown : Bool = false;
    
    init(frame: CGRect, _level: GLSLevelData){
        level = _level;
        super.init(frame: frame);
        self.isUserInteractionEnabled = true;
        
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

class GLSLevelDetailView : UIView {
    
    var topView : UIView!;
    var leftView : UIView!;
    var rightView : UIView!;
    var bottomView : UIView!;
    
    init(frame : CGRect, tileView : GLSSelectTile){
        //need to draw view around tileView
        
        super.init(frame: frame)
        
        let tF = tileView.frame
        //TODO paddings
        let widthFromLeftEdgeToTileRightEdge = tF.origin.x
        let heightFromTopEdgeToTileTopEdge = tF.origin.y

        let widthFromTileRightEdgeToRightEdge = frame.width-(tF.origin.x+tF.width)
        let heightFromTileBottomEdgeToBottomEdge = frame.height-(tF.origin.y+tF.height)

        topView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: heightFromTopEdgeToTileTopEdge))
        topView.backgroundColor = UIColor.black
        self.addSubview(topView)
        
        leftView = UIView(frame: CGRect(x: 0, y: heightFromTopEdgeToTileTopEdge, width: widthFromLeftEdgeToTileRightEdge, height: tF.height))
        leftView.backgroundColor = UIColor.green
        self.addSubview(leftView)
        
        rightView = UIView(frame: CGRect(x: tF.origin.x+tF.width, y: heightFromTopEdgeToTileTopEdge, width: widthFromTileRightEdgeToRightEdge, height: tF.height))
        rightView.backgroundColor = UIColor.red
        self.addSubview(rightView)
        
        bottomView = UIView(frame: CGRect(x: 0, y: heightFromTopEdgeToTileTopEdge+tF.height, width: frame.width, height: heightFromTileBottomEdgeToBottomEdge))
        bottomView.backgroundColor = UIColor.orange
        self.addSubview(bottomView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
