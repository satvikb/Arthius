//
//  LevelView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol LevelViewDelegate: class {
    func level_pressMenu()
}

class LevelView : UIView {
    
    var level : Level!; //The current level, up to date with user created items.
    //var resetToLevel :  Level!; //The level it is reset to after clicking restart, without user interaction.
    
    var levelView : LevelScrollView!;

    weak var levelViewDelegate:LevelViewDelegate?

    
    var lastPoint: CGPoint!
    var endRectScaled : CGRect!;
    
    var linePath : UIBezierPath!;
    var lineShape : CAShapeLayer!;
    
    var lineVelocity: CGVector!;
    var lineColor : Color!;
    
    var tempLineForces : CGVector! = CGVector.zero;
    var lineMass : CGFloat = 1; //no effect for now?
    let G : CGFloat = 1;
    
    
    var playResetBtn : Button!;
    var homeBtn : Button!;

    //Create scaled arrays to store the level elements that are scaled up to the current device size. TODO: Do this for all the other level elements.
    //This is created because the GravityWellData in LevelData stores the proportional sizes. Instead of converting from prop to real in the update look, it's easier to just store the scaled wells as well.
    //This is what is used for calculations, GravityWellData is what is used to save.
    var scaledGravityWells : [GravityWell] = []
    var scaledColorBoxes : [ColorBox] = []
    
    
    var displayLink : CADisplayLink!
    
    
    var paused = true;
    
    
    init(_level: Level){
        level = _level;
        super.init(frame: UIScreen.main.bounds)

        lastPoint = propToPoint(prop: level.levelData.startPosition);
        lineVelocity = propToVector(prop: level.levelData.startVelocity);
        endRectScaled = propToRect(prop: level.levelData.endPosition);
        lineColor = level.levelData.startColor;
        
        setupLevelView()
        setupLine()
        setupLevelEnd()
        setupGestureRecognizers()
        createLevelElementsFromLevel()
        createUIButtons()

        start()
    }
    
    func setupLevelView(){
        levelView = LevelScrollView(frame: UIScreen.main.bounds)
        levelView.isUserInteractionEnabled = true;
        levelView.bounces = false;
        levelView.showsVerticalScrollIndicator = false;
        levelView.showsHorizontalScrollIndicator = false;
        levelView.delaysContentTouches = false;
        levelView.contentSize = propToRect(prop: level.levelData.propFrame).size
        self.addSubview(levelView)
    }
    
    func setupGestureRecognizers(){
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        //        singleTap.numberOfTapsRequired = 1
        //        singleTap.delegate = self;
        singleTap.minimumPressDuration = 0.1;
        singleTap.allowableMovement = propToFloat(prop: 0.7, scaleWithX: true) //pretty much maximum size well that can be created when initally created
        levelView.addGestureRecognizer(singleTap)
    }
    
    func setupLine(){
        linePath = UIBezierPath();
        linePath.move(to: self.lastPoint);

        lineShape = CAShapeLayer();
        lineShape.frame = levelView.frame
        lineShape.path = linePath.cgPath;
        lineShape.lineCap = kCALineCapRound;
        lineShape.fillColor = UIColor.clear.cgColor;
        lineShape.lineWidth = 10;
        lineShape.strokeColor = ColorBox.ColorToUIColor(col: lineColor).cgColor;
        lineShape.zPosition = 100;
        self.levelView.layer.addSublayer(lineShape)
    }
    
    func setupLevelEnd(){
        let endRect = UIView(frame: endRectScaled)
        endRect.backgroundColor = UIColor.green
        self.levelView.addSubview(endRect)
    }
    
    func createUIButtons(){
        playResetBtn = Button(propFrame: CGRect(x: 0.9, y: 0, width: 0.1, height: 0.1), text: ">", fontSize: Screen.fontSize(propFontSize: 20))
        playResetBtn.pressed = {
            if(self.paused == true){
                //play
                self.paused = false
                self.playResetBtn.text.text = "R"
            }else if(self.paused == false){
                //currently playing, pause and reset level
                self.paused = true;
                self.resetLine()
            }
        }
        
        homeBtn = Button(propFrame: CGRect(x: 0, y: 0, width: 0.15, height: 0.1), text: "H", fontSize: Screen.fontSize(propFontSize: 20))
        homeBtn.pressed = {
            //TODO confirmation?
            self.stop()
            self.levelViewDelegate?.level_pressMenu()
        }
        
        self.addSubview(playResetBtn);
        self.addSubview(homeBtn);
    }
    
    func createLevelElementsFromLevel(){
        createGravityWellsFromLevel()
        createColorBoxesFromLevel()
    }
    
    func createGravityWellsFromLevel(){
        
        for gWell in level.levelData.gravityWells {
            let _ = createGravityWell(point: propToPoint(prop: gWell.position), core: propToFloat(prop: gWell.coreDiameter, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: gWell.areaOfEffectDiameter, scaleWithX: true), mass: gWell.mass, new: false)
        }
        
    }
    
    func createColorBoxesFromLevel(){
        for cBox in level.levelData.colorBoxData {
            let _ = createColorBox(frame: propToRect(prop: cBox.frame), rotation: cBox.rotation, box: cBox.box, leftCol: cBox.leftColor, rightCol: cBox.rightColor, backgroundColor: cBox.backgroundColor, middlePropWidth: cBox.middlePropWidth)
        }
    }
    
    func resetLine(){
        
        lastPoint = propToPoint(prop: level.levelData.startPosition);//CGPoint(x: 120, y: UIScreen.main.bounds.size.height)
        lineVelocity = propToVector(prop: level.levelData.startVelocity);
        lineColor = level.levelData.startColor;
            
        self.linePath = UIBezierPath();
        self.lineShape.path = nil;
        self.playResetBtn.text.text = ">"
        linePath.move(to: self.lastPoint);
        lineShape.strokeColor = ColorBox.ColorToUIColor(col: lineColor).cgColor
    }
    
    var longTapInital : CGPoint = CGPoint.zero;
    var currentGravityWellCreated : GravityWell!;
    
    @objc func handleTap(_ recognizer: UIGestureRecognizer) {
        // Perform operation
        if(recognizer.state == .began){
            longTapInital = recognizer.location(in: recognizer.view)
            currentGravityWellCreated = createGravityWell(point: longTapInital, core: propToFloat(prop: 0.015, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: 0.05, scaleWithX: true), mass: 100, new: true)
            print("start long")
        }else if(recognizer.state == .changed){
            let p = recognizer.location(in: recognizer.view)
            let d : CGFloat = CGFloat(sqrtf(Float(pow(p.x-longTapInital.x, 2) + pow(p.y-longTapInital.y, 2))))
            
            print(d)
            currentGravityWellCreated.areaOfEffectDiameter = d*2;
            currentGravityWellCreated.coreDiameter = d/2; // 1/4 ratio
            //TODO
            //currentGravityWellCreated.mass =
            currentGravityWellCreated.updateSize()
        }
        
//        let touchLocation: CGPoint = recognizer.location(in: recognizer.view)
//
//        recognizer.view!.backgroundColor = UIColor.black
//        print(touchLocation, (self.next as! UIView).tag, recognizer.view!.tag)
//
//        createGravityWell(point: touchLocation, core: propToFloat(prop: 0.2, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: 0.6, scaleWithX: true), mass: 200, new: true)
    }
    
    func createGravityWell(point: CGPoint, core: CGFloat, areaOfEffectDiameter: CGFloat, mass: CGFloat, new: Bool) -> GravityWell{
        let newWell = GravityWell(corePoint: point, coreDiameter: core, areaOfEffectDiameter: areaOfEffectDiameter, mass: mass)

        levelView.addSubview(newWell)
        newWell.touched = {
            newWell.removeFromSuperview()
            self.scaledGravityWells.remove(at: self.scaledGravityWells.index(of: newWell)!)
        }

        newWell.layer.zPosition = -100
        scaledGravityWells.append(newWell)
        
        return newWell;
    }
    
    func createColorBox(frame : CGRect, rotation : CGFloat, box : Bool, leftCol : Color, rightCol : Color, backgroundColor: Color, middlePropWidth : CGFloat) -> ColorBox{
        let newBox = ColorBox(frame: frame, rotation: rotation, box: box, _leftColor: leftCol, _rightColor: rightCol, backgroundColor: backgroundColor, _middlePropWidth: middlePropWidth)
        
        levelView.addSubview(newBox)
        scaledColorBoxes.append(newBox)
        
        return newBox
    }
    
    func snapshot(){
        let levelSave = level;
        
        //update levelData using scaledGravityWells
        var gravityWellData : [GravityWellData] = []
        for scaledGravWell in scaledGravityWells {
            gravityWellData.append(scaledGravWell.data)
        }
        levelSave!.levelData.gravityWells = gravityWellData;
    }
    
    func newMoveLocation(p: CGPoint){
        //TODO only call once at init
//        linePath.move(to: self.lastPoint);

        linePath.addLine(to: p)
        
        lineShape.path = linePath.cgPath;
        lineShape.didChangeValue(forKey: "path")
        
        self.lastPoint = p;
    }
    
    func changeLineColor(to: Color){
        lineColor = to;
        lineShape.strokeColor = ColorBox.ColorToUIColor(col: to).cgColor
    }
    
    @objc func update(){
        if(paused == false){
            tempLineForces = CGVector.zero;
            
            for gravWell in scaledGravityWells{
                let distFromGravityCenter = distance(a: lastPoint, b: gravWell.center)
                if(distFromGravityCenter < gravWell.areaOfEffectDiameter/2){
                    let f = (G * gravWell.mass * lineMass) / (distFromGravityCenter*distFromGravityCenter)
                    
                    let p2 = gravWell.center;
                    let p1 = lastPoint!;
                    let angleRad = atan2(p2.y - p1.y, p2.x - p1.x)
                    
                    let fx = f*cos(angleRad)
                    let fy = f*sin(angleRad)
                    tempLineForces = tempLineForces + (CGVector(dx: fx, dy: fy))
                }
            }
            
            //pemdas
            let dV = tempLineForces / lineMass
            lineVelocity = lineVelocity + dV
            
            let deltaVel = lineVelocity!// * CGFloat(displayLink.duration)
            let pos = lastPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
            newMoveLocation(p: pos);
            
            if(endRectScaled.contains(lastPoint)){
                print("GAME")
                //finish level
            }
            
            for cBox in scaledColorBoxes {
                
                if(cBox.pointInRect(locInMain: lastPoint)){
                    cBox.lineInBox = true;
                    
                    if(cBox.pointInLeftRect(locInMain: lastPoint)){
                        
                        //line entered from left
                        if(cBox.lineOnASide == false && lineColor == cBox.leftColor){
                            cBox.lineOnASide = true;
                            cBox.lineOnLeftSide = true;
                            print("IN LEFT")
                        }else{
                            //line entered from right
                            if(cBox.lineOnLeftSide == false){
                                print("Change Color R-L")
                                changeLineColor(to: cBox.leftColor)
                            }
                        }
                    }
                    
                    if(cBox.pointInRightRect(locInMain: lastPoint)){
                        
                        //coming from left
                        if(cBox.lineOnASide == true){
                            if(cBox.lineOnLeftSide == true){
                                print("Change Color L-R")
                                changeLineColor(to: cBox.rightColor)
                            }
                        }else{
                            if(lineColor == cBox.rightColor){
                                cBox.lineOnASide = true;
                                cBox.lineOnLeftSide = false;
                                print("IN RIGHT")
                            }
                        }
                    }
                }else{
                    cBox.lineInBox = false;
                    cBox.lineOnASide = false;
                    cBox.lineOnLeftSide = false;
                }
                
                
            }
        }
    }
    
    func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func stop() {
        if(displayLink != nil){ //pressing home twice
            displayLink.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
            displayLink = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
