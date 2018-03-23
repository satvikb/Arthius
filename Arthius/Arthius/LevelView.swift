//
//  LevelView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class LevelView : UIView {
    
    
    var level : Level!;
    
    var levelView : UIScrollView!;

    var lastPoint: CGPoint!
    var endRectScaled : CGRect!;
    
    var lineView : UIView!;
    var lineVelocity: CGVector!;
    var tempLineForces : CGVector! = CGVector.zero;
    var lineMass : CGFloat = 1; //no effect for now?
    let G : CGFloat = 1;
    
    //Create scaled arrays to store the level elements that are scaled up to the current device size. TODO: Do this for all the other level elements.
    //This is created because the GravityWellData in LevelData stores the proportional sizes. Instead of converting from prop to real in the update look, it's easier to just store the scaled wells as well.
    //This is what is used for calculations, GravityWellData is what is used to save.
    var scaledGravityWells : [GravityWell] = []
    
    private var buffer: UIImage?
    var displayLink : CADisplayLink!
    
    
    init(_level: Level) {
        level = _level;
        
        super.init(frame: UIScreen.main.bounds)//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
        self.tag = 12;

        endRectScaled = propToRect(prop: level.levelData.endPosition);
        
        
        levelView = UIScrollView(frame: UIScreen.main.bounds)//propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)))
        levelView.isUserInteractionEnabled = true;
        levelView.bounces = false;
        levelView.showsVerticalScrollIndicator = false;
        levelView.showsHorizontalScrollIndicator = false;
        levelView.contentSize = propToRect(prop: _level.levelData.propFrame).size//CGRect(x: 0, y: 0, width: 3, height: 1)).size
        
        print(levelView.contentSize)
        lineView = UIView(frame: CGRect(origin: levelView.frame.origin, size: levelView.contentSize))
        self.levelView.addSubview(lineView)
        
        
        let endRect = UIView(frame: endRectScaled)
        endRect.backgroundColor = UIColor.green
        self.levelView.addSubview(endRect)
        
        
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        levelView.addGestureRecognizer(singleTap)
        
        
        for gWell in level.levelData.gravityWells {
            createGravityWell(point: propToPoint(prop: gWell.position), core: propToFloat(prop: gWell.coreDiameter, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: gWell.areaOfEffectDiameter, scaleWithX: true), mass: gWell.mass, new: false, saveGame: false)
        }
//        createGravityWell(point: CGPoint(x: UIScreen.main.bounds.size.width/2, y: 230), core: 40, areaOfEffectDiameter: 200, mass: 250)
//        createGravityWell(point: CGPoint(x: UIScreen.main.bounds.size.width/5, y: 230), core: 40, areaOfEffectDiameter: 300, mass: 200)
//        createGravityWell(point: CGPoint(x: UIScreen.main.bounds.size.width/2+40, y: 450), core: 40, areaOfEffectDiameter: 240, mass: 60)
        
        lastPoint = propToPoint(prop: level.levelData.startPosition);//CGPoint(x: 120, y: UIScreen.main.bounds.size.height)
        lineVelocity = propToVector(prop: level.levelData.startVelocity);
        
        self.addSubview(levelView)

        start()

    }
    
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        // Perform operation
        
        let touchLocation: CGPoint = recognizer.location(in: recognizer.view)
        
        recognizer.view!.backgroundColor = UIColor.black
        print(touchLocation, (self.next as! UIView).tag, recognizer.view!.tag)
        
        createGravityWell(point: touchLocation, core: propToFloat(prop: 0.2, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: 0.6, scaleWithX: true), mass: 200, new: true, saveGame: true)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if self.next != nil {
//            self.next?.touchesBegan(touches, with: event)
//        }else{
//
//        }
//    }
    
//    var i = 14;
    
    func createGravityWell(point: CGPoint, core: CGFloat, areaOfEffectDiameter: CGFloat, mass: CGFloat, new: Bool, saveGame: Bool/*TEMP*/){
        let newWell = GravityWell(corePoint: point, coreDiameter: core, areaOfEffectDiameter: areaOfEffectDiameter, mass: mass)
//        newWell.mass = mass;
        levelView.addSubview(newWell)
        newWell.touched = {
            newWell.removeFromSuperview()
            self.level.levelData.gravityWells.remove(at: self.level.levelData.gravityWells.index(of: newWell.data)!)
            self.scaledGravityWells.remove(at: self.scaledGravityWells.index(of: newWell)!)
            self.TEMP_SAVE()
        }
//        newWell.tag = i;
//        i += 1;
        scaledGravityWells.append(newWell)
        if(new == true){
            self.level.levelData.gravityWells.append(newWell.data)
        }
        
        //todo temp
        if(saveGame){
            TEMP_SAVE()
        }
    }

    func TEMP_SAVE(){
        do{
            try Disk.remove("level.json", from: .documents)
            try Disk.save(level.levelData, to: .documents, as: "level.json")
            print("saved new")
            
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("level.json") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE "+filePath)
                    
                    var fileSize : UInt64
                    
                    do {
                        //return [FileAttributeKey : Any]
                        let attr = try FileManager.default.attributesOfItem(atPath: filePath)
                        fileSize = attr[FileAttributeKey.size] as! UInt64
                        
                        //if you convert to NSDictionary, you can get file size old way as well.
                        let dict = attr as NSDictionary
                        fileSize = dict.fileSize()
                        
                        print(fileSize, "bytes")
                    } catch {
                        print("Error: \(error)")
                    }
                    
                    
                } else {
                    print("FILE NOT AVAILABLE")
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
            }
        } catch let error as NSError{
            fatalError("""
                Domain: \(error.domain)
                Code: \(error.code)
                Description: \(error.localizedDescription)
                Failure Reason: \(error.localizedFailureReason ?? "")
                Suggestions: \(error.localizedRecoverySuggestion ?? "")
                """)
        }
        
    }
    
    
    private func drawLine(a: CGPoint, b: CGPoint, buffer: UIImage?) -> UIImage {
        let size = self.lineView.bounds.size
        
        // Initialize a full size image. Opaque because we don't need to draw over anything. Will be more performant.
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.lineView.backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context?.fill(self.lineView.bounds);
        // Draw previous buffer first
        if let buffer = buffer {
            buffer.draw(in: self.lineView.bounds)
        }
        
        // Draw the line
        
        UIColor.blue.setStroke()
        context?.setLineWidth(8);
        context?.setLineCap(CGLineCap.round)
        context?.move(to: a);
        context?.addLine(to: b);
        context?.strokePath()
        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func newMoveLocation(p: CGPoint){
        self.buffer = self.drawLine(a: self.lastPoint, b: p, buffer: self.buffer)
        
        // 3. Replace the layer contents with the updated image
        self.lineView.layer.contents = self.buffer?.cgImage ?? nil
        self.lastPoint = p;
    }
    
    
    @objc func update(){
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
        displayLink.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
