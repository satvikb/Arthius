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
    var tempLineForces : CGVector! = CGVector.zero;
    var lineMass : CGFloat = 1; //no effect for now?
    let G : CGFloat = 1;
    
    
    var playResetBtn : Button!;
    var homeBtn : Button!;

    //Create scaled arrays to store the level elements that are scaled up to the current device size. TODO: Do this for all the other level elements.
    //This is created because the GravityWellData in LevelData stores the proportional sizes. Instead of converting from prop to real in the update look, it's easier to just store the scaled wells as well.
    //This is what is used for calculations, GravityWellData is what is used to save.
    var scaledGravityWells : [GravityWell] = []
    
    var displayLink : CADisplayLink!
    
    
    var paused = true;
    
    
    init(_level: Level){//, _resetToLevel : Level) {
        level = _level;
//        resetToLevel = _resetToLevel;
        
        super.init(frame: UIScreen.main.bounds)//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        self.tag = 12;

        lastPoint = propToPoint(prop: level.levelData.startPosition);//CGPoint(x: 120, y: UIScreen.main.bounds.size.height)
        lineVelocity = propToVector(prop: level.levelData.startVelocity);
        
        
        endRectScaled = propToRect(prop: level.levelData.endPosition);
        
        levelView = LevelScrollView(frame: UIScreen.main.bounds)//propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)))
        levelView.isUserInteractionEnabled = true;
        levelView.bounces = false;
        levelView.showsVerticalScrollIndicator = false;
        levelView.showsHorizontalScrollIndicator = false;
        levelView.delaysContentTouches = false;
        levelView.contentSize = propToRect(prop: _level.levelData.propFrame).size//CGRect(x: 0, y: 0, width: 3, height: 1)).size
        
        print(levelView.contentSize)
        
        
        linePath = UIBezierPath();
        lineShape = CAShapeLayer();
        lineShape.frame = levelView.frame
        lineShape.path = linePath.cgPath;
        lineShape.lineCap = kCALineCapRound;
        lineShape.fillColor = UIColor.blue.cgColor;
        lineShape.lineWidth = 10;
        lineShape.strokeColor = UIColor.green.cgColor
        lineShape.zPosition = 100;
        self.levelView.layer.addSublayer(lineShape)
        
        let endRect = UIView(frame: endRectScaled)
        endRect.backgroundColor = UIColor.green
        self.levelView.addSubview(endRect)
        
        
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.cancelsTouchesInView = false
//        singleTap.numberOfTapsRequired = 1
//        singleTap.delegate = self;
        singleTap.minimumPressDuration = 0.1;
        singleTap.allowableMovement = propToFloat(prop: 0.7, scaleWithX: true) //pretty much maximum size well that can be created when initally created
        levelView.addGestureRecognizer(singleTap)
        
        
        for gWell in level.levelData.gravityWells {
            let _ = createGravityWell(point: propToPoint(prop: gWell.position), core: propToFloat(prop: gWell.coreDiameter, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: gWell.areaOfEffectDiameter, scaleWithX: true), mass: gWell.mass, new: false)
        }

        
        self.addSubview(levelView)

        
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
                
                //remove all gravity wells. WAIT NO. RESTARTING THE LEVEL DOESNT REMOVE WELLS LOL ONLY RESTARTS THE LINE NVM
//                for well in self.scaledGravityWells{
//                    well.removeFromSuperview()
//
//                }
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

        start()

    }
    
    func resetLine(){
        
        self.linePath = UIBezierPath();
        self.lineShape.path = nil;
        self.playResetBtn.text.text = ">"

        lastPoint = propToPoint(prop: level.levelData.startPosition);//CGPoint(x: 120, y: UIScreen.main.bounds.size.height)
        lineVelocity = propToVector(prop: level.levelData.startVelocity);
        
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
        linePath.move(to: self.lastPoint);

        linePath.addLine(to: p)
        
        lineShape.path = linePath.cgPath;
        lineShape.didChangeValue(forKey: "path")
        
        self.lastPoint = p;
    }
    
    
    @objc func update(){
        if(paused == false){
            tempLineForces = CGVector.zero;
            
            for gravWell in scaledGravityWells{
                let distFromGravityCenter = distance(a: lastPoint, b: gravWell.center)
                if(distFromGravityCenter < gravWell.areaOfEffectDiameter/2){
                    ////                let v = sqrt( G * gravWell.mass / (gravWell.areaOfEffectDiameter/2) )
                    let f = (G * gravWell.mass * lineMass) / (distFromGravityCenter*distFromGravityCenter)
                    
                    
                    let p2 = gravWell.center;
                    let p1 = lastPoint!;
                    let angleRad = atan2(p2.y - p1.y, p2.x - p1.x)// * 180 / CGFloat.pi;
                    
                    let fx = f*cos(angleRad)
                    let fy = f*sin(angleRad)
                    tempLineForces = tempLineForces + (CGVector(dx: fx, dy: fy))
        //                print(fx, fy, f, lineVelocity, distFromGravityCenter, tempLineForces)
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
        }
    }
    
    func CGVectorDotProduct(vector1 : CGVector, vector2 : CGVector) -> CGFloat{
        return vector1.dx * vector2.dx + vector1.dy * vector2.dy;
    }
    
    func CGVectorLength(vector : CGVector) -> Float
    {
        return hypotf(Float(vector.dx), Float(vector.dy));
    }
    
    
    func CGVectorMultiplyByScalar(vector : CGVector, value : CGFloat) -> CGVector{
        return CGVector(dx: vector.dx * value, dy: vector.dy * value);
    }
    
    func CGVectorNormalize(vector : CGVector) -> CGVector {
        let length : CGFloat = CGFloat(CGVectorLength(vector: vector));
        
        if (length == 0) {
            return CGVector.zero
        }
        
        let scale : CGFloat = 1.0 / length;
        return CGVectorMultiplyByScalar(vector: vector, value: scale);
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
    
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if(otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)){
//            return true
//        }
//        return false
//    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
