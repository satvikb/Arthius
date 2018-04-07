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


protocol GLSDetailViewDelegate : class {
    func pressedPlay(_ tile : GLSSelectTile)
    func exit()
}

//used in gls level selector
class GLSLevelSelector : UIScrollView, GLSDetailViewDelegate {
    
    weak var glsSelectorDelegate:GLSSelectorDelegate?
    var levels : [GLSLevelData]!
    var xTiles : CGFloat!
    var yTiles : CGFloat!
    
    var showingDetailView : Bool = false;
    var startedLoadingLevel : Bool = false;
    
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
            levelTile.backgroundColor = UIColor.clear
            levelTile.layer.borderColor = UIColor.black.cgColor
            levelTile.layer.borderWidth = 2;
            
            print("Showing Level Tile: \(level.levelUUID)")
            glsSelectorDelegate?.getThumbnail(levelUUID: level.levelUUID, completion: {(img : UIImage) in
                levelTile.image = img
                print("Showing Level Thumb: \(level.levelUUID)")
            })
            
            
            levelTile.pressed = {(levelData : GLSLevelData) in
                
                let paddings = self.propToRect(prop: CGRect(x: sidePadding, y: topPadding, width: xMiddlePadding, height: yMiddlePadding), within: self.bounds)
                
                self.showLevelDetailView(levelTile: levelTile, sidePadding: paddings.origin.x, topPadding: paddings.origin.y, xMiddlePadding: paddings.size.width, yMiddlePadding: paddings.size.height)
                
//                self.glsSelectorDelegate?.levelSelector_pressedLevel(level: levelData)
            }
            
            self.addSubview(levelTile)
            i += 1;
        }
        
        self.contentSize = propToRectSelf(prop: CGRect(x: 0, y: 0, width: 1, height: 1)).size
    }
    
    func showLevelDetailView(levelTile : GLSSelectTile, sidePadding: CGFloat, topPadding: CGFloat, xMiddlePadding: CGFloat, yMiddlePadding: CGFloat){
        
        if(!self.showingDetailView){
            self.showingDetailView = true;
            
            let detailView : GLSLevelDetailView = GLSLevelDetailView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), tileView: levelTile, sidePadding: sidePadding, topPadding: topPadding, xMiddlePadding: xMiddlePadding, yMiddlePadding: yMiddlePadding);
            detailView.delegate = self
            self.addSubview(detailView)
            detailView.animateIn()
        }
    }
    
    func propToRectSelf(prop: CGRect) -> CGRect {
        let screen = self.bounds
        return CGRect(x: prop.origin.x * screen.width, y: prop.origin.y * screen.height, width: screen.width*prop.width, height: screen.height*prop.height)
    }
    
    //TODO Animate
    func animateIn(){
        showingDetailView = false
        startedLoadingLevel = false
    }
    
    func animateOut(){
        showingDetailView = false
        startedLoadingLevel = false
    }
    
    func exit() {
        self.showingDetailView = false
    }
    
    func pressedPlay(_ tile : GLSSelectTile) {
        if(!startedLoadingLevel){
            startedLoadingLevel = true;
            glsSelectorDelegate?.globalLevelSelector_pressedPlayLevel(level: tile.level)
        }
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


class GLSLevelDetailView : UIView {
    
    var tileView : GLSSelectTile!;
    var topView : UIView!;
    var leftView : UIView!;
    var rightView : UIView!;
    var bottomView : UIView!;
    
    var playButton : Button!
    
    var downloadCount : Label!
    
    weak var delegate : GLSDetailViewDelegate?
    
    init(frame : CGRect, tileView : GLSSelectTile, sidePadding: CGFloat, topPadding: CGFloat, xMiddlePadding: CGFloat, yMiddlePadding: CGFloat){
        //need to draw view around tileView
        self.tileView = tileView;
        
        super.init(frame: frame)
        
        let tF = tileView.frame
        
        //TODO paddings, labels
        let widthFromLeftEdgeToTileRightEdge = tF.origin.x
        let heightFromTopEdgeToTileTopEdge = tF.origin.y

        let widthFromTileRightEdgeToRightEdge = frame.width-(tF.origin.x+tF.width)
        let heightFromTileBottomEdgeToBottomEdge = frame.height-(tF.origin.y+tF.height)

        topView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: heightFromTopEdgeToTileTopEdge-yMiddlePadding))
        topView.backgroundColor = UIColor.black
        self.addSubview(topView)
        
        leftView = UIView(frame: CGRect(x: 0, y: heightFromTopEdgeToTileTopEdge, width: widthFromLeftEdgeToTileRightEdge-xMiddlePadding, height: tF.height))
        leftView.backgroundColor = UIColor.green
        self.addSubview(leftView)
        
        rightView = UIView(frame: CGRect(x: tF.origin.x+tF.width+xMiddlePadding, y: heightFromTopEdgeToTileTopEdge, width: widthFromTileRightEdgeToRightEdge-xMiddlePadding, height: tF.height))
        rightView.backgroundColor = UIColor.red
        self.addSubview(rightView)
        
        bottomView = UIView(frame: CGRect(x: 0, y: heightFromTopEdgeToTileTopEdge+tF.height+yMiddlePadding, width: frame.width, height: heightFromTileBottomEdgeToBottomEdge-yMiddlePadding))
        bottomView.backgroundColor = UIColor.orange
        self.addSubview(bottomView)
        
        playButton = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0.7, width: 0.8, height: 0.2), within: bottomView.frame), text: "play", fontSize: Screen.fontSize(propFontSize: 20), outPos: propToRect(prop: CGRect(x: -1, y: 0.7, width: 0, height: 0), within: getOpenViewForPlayButton().frame).origin)
        playButton.pressed = {
            self.delegate?.pressedPlay(self.tileView)
        }
        getOpenViewForPlayButton().addSubview(playButton)
        
        
        downloadCount = Label(frame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.2), within: getOpenViewForDownloadCounter().frame), text: "D: \(tileView.level.downloads)", _outPos: CGPoint(x: -1, y: 0.05), textColor: UIColor.white, valign: VAlign.Default, _insets: false)
//        DownloadCounter.getDownloadCountFor(uuid: tileView.level.levelUUID, completion: {(downloads : Int) in
//
//        })
        getOpenViewForDownloadCounter().addSubview(downloadCount)
        
    }
    
    //TODO
    func getOpenViewForTitle() -> UIView{
        return topView
    }
    
    func getOpenViewForPlayButton() -> UIView{
        return bottomView
    }
    
    func getOpenViewForDownloadCounter() -> UIView{
        return rightView
    }
//
//    func getOpenViewLeftRight() -> UIView{
//
//    }
    
    func animateIn(){
        playButton.animateIn()
    }
    
    func animateOut(){
        playButton.animateOut()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
        delegate?.exit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
