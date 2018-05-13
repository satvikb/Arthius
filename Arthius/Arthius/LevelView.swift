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
    func level_nextLevel(currentLevelNumber: Int)
}

class Line : CAShapeLayer{
    
    var startPosition : CGPoint!;
    var startVelocity : CGVector!;
    var startColor : Color!;
    var startThickness : CGFloat!;
    
    var currentPoint: CGPoint!
    var linePath : UIBezierPath!;
//    var lineShape : CAShapeLayer!;
    var lineVelocity: CGVector!;
    var lineColor : Color!;
    var lineThickness : CGFloat!;
    
    var lineMass : CGFloat = 1; //no effect for now?
    var tempLineForces : CGVector! = CGVector.zero;

    var madeItToEnd : Bool = false;
    
    var currentPointView : CAShapeLayer!;
    
//    var startView : UIView!; //For editable
    
    
    var levelCountTimer : Double = 0;
    var levelCountDistance : CGFloat = 0;
    
    
    //oh why not, too much work to have an incremental number ID system
    var uuid : String!
    
    //TODO: frame: should be just the screen bounds, or should it be level bounds (sizes bigger than screen)?
    init(frame: CGRect, _startPoint : CGPoint, _startVelocity : CGVector, _startColor : Color, _startThickness : CGFloat) {
        startPosition = _startPoint;
        startVelocity = _startVelocity;
        startColor = _startColor;
        startThickness = _startThickness;
        
        lineColor = startColor;
        currentPoint = startPosition;
        lineVelocity = startVelocity;

        lineThickness = 10;
        
        uuid = UUID().uuidString
        
        super.init()
        
        self.frame = frame;
        self.lineCap = kCALineCapRound;
        self.fillColor = UIColor.clear.cgColor;
        self.lineWidth = lineThickness;
        updateStrokeColor()
        self.zPosition = 100;
        
        currentPointView = CAShapeLayer()
        currentPointViewUpdate()
        self.addSublayer(currentPointView)
        
        reset()
    }
    
    func currentPointViewUpdate(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        currentPointView.frame = currentPointViewFrame()
        currentPointView.fillColor = UIColor.orange.cgColor
        currentPointView.path = circlePath().cgPath
        
        CATransaction.commit()
    }
    
    func circlePath() -> UIBezierPath {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: lineThickness/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        return circlePath
    }
    
    func currentPointViewFrame() -> CGRect{
        return CGRect(x: currentPoint.x, y: currentPoint.y, width: lineThickness/2, height: lineThickness/2)
    }
    
    func reset(){
        currentPoint = startPosition;
        lineVelocity = startVelocity;
        lineColor = startColor;
        lineThickness = startThickness;
        madeItToEnd = false;
        
        linePath = UIBezierPath();
        linePath.move(to: currentPoint)
        path = nil;
        
        currentPointViewUpdate()
        updateStrokeColor()
        updateLineThickness()
    }
    
    func newLocation(p: CGPoint){
        linePath.addLine(to: p);
        path = linePath.cgPath;
        didChangeValue(forKey: "path")
        currentPoint = p;
        
        currentPointViewUpdate()
    }
    
    func changeLineColor(to: Color){
        lineColor = to;
        updateStrokeColor()
    }
    
    func updateStrokeColor(){
        self.strokeColor = lineColor.uiColor().cgColor
    }
    
    func updateLineThickness(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        lineWidth = lineThickness
        CATransaction.commit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
}

class DummyLine : CAShapeLayer{

    var currentPoint: CGPoint!
    var linePath : UIBezierPath!;
    //    var lineShape : CAShapeLayer!;
    var lineColor : Color!;
    var lineThickness : CGFloat!;

    
    var levelCountTimer : Double = 0;
    var levelCountDistance : CGFloat = 0;
    
    
    //oh why not, too much work to have an incremental number ID system
    var uuid : String!
    
    //TODO: frame: should be just the screen bounds, or should it be level bounds (sizes bigger than screen)?
    init(frame: CGRect, _startPoint : CGPoint, _startColor : Color, _startThickness : CGFloat) {
        lineColor = _startColor;
        lineThickness = _startThickness;
        currentPoint = _startPoint;

        uuid = UUID().uuidString
        
        linePath = UIBezierPath();
        linePath.move(to: currentPoint)
        
        
        super.init()
        
        self.frame = frame;
        self.path = linePath.cgPath;
        self.lineCap = kCALineCapRound;
        self.fillColor = UIColor.clear.cgColor;
        self.lineWidth = lineThickness;
        updateStrokeColor()
        self.zPosition = 100;
        
        path = nil;
    }
    
    func newLocation(p: CGPoint){
        linePath.addLine(to: p);
        path = linePath.cgPath;
        didChangeValue(forKey: "path")
        currentPoint = p;
        
    }
    
    func updateStrokeColor(){
        self.strokeColor = lineColor.uiColor().cgColor
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
}

class LevelEnd : UIView{
    var color : Color!;
    
//    var endView : UIView!; //For editable
    
    init(_innerFrame : CGRect, _color : Color) {
        super.init(frame: _innerFrame)
        color = _color
        self.backgroundColor = _color.uiColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AntiGravityZone : UIView{
    var color : Color!;
    
    init(_innerFrame : CGRect, _color : Color) {
        super.init(frame: _innerFrame)
        color = _color
        self.backgroundColor = _color.uiColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LevelView : UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var level : Level!; //The current level, up to date with user created items.
    var parentView : View!;
    //var resetToLevel :  Level!; //The level it is reset to after clicking restart, without user interaction.
    
    var levelView : LevelScrollView!;
    var stageView : UIView!;

    weak var levelViewDelegate:LevelViewDelegate?

    var lines : [Line] = []
    var drawLines : [DummyLine] = [];
    var endPoints : [LevelEnd] = []
    var antiGravityZones : [AntiGravityZone] = []
    
    let G : CGFloat = 1;
    
    var playResetBtn : Button!;
    var homeBtn : Button!;

    var campaignLevel : Bool = false;
    var beatLevel : Bool = false;
    
    //Create scaled arrays to store the level elements that are scaled up to the current device size. TODO: Do this for all the other level elements.
    //This is created because the GravityWellData in LevelData stores the proportional sizes. Instead of converting from prop to real in the update look, it's easier to just store the scaled wells as well.
    //This is what is used for calculations, GravityWellData is what is used to save.
    var scaledGravityWells : [GravityWell] = []
    var scaledColorBoxes : [ColorBox] = []
    
    var displayLink : CADisplayLink!
    var paused = false;
    
    
    var currentTextsLabel : LevelTextsLabel!;
    var currentText : LevelText!;
//    var currentTrigger : LevelTextTriggers!; // Within currentText
    
    var changeBordersBasedOnZoom : Bool = true

    
    init(_level: Level, _parentView: View, _campaignLevel: Bool = false){
        level = _level;
        parentView = _parentView;
        campaignLevel = _campaignLevel
        super.init(frame: UIScreen.main.bounds)

        self.backgroundColor = UIColor.white
        
        
        setupLevelView()
        
        setupLines()
        setupLevelEnds()
        setupAntiGrvityZones()
        
        setupGestureRecognizers()
        createLevelElementsFromLevel()
        createUIButtons()
        setupLevelTexts()
        
        start()
    }
    
    func setupLevelView(){
        levelView = LevelScrollView(frame: UIScreen.main.bounds)
        levelView.backgroundColor = UIColor.white
        levelView.isUserInteractionEnabled = true;
        levelView.bounces = false;
        levelView.showsVerticalScrollIndicator = false;
        levelView.showsHorizontalScrollIndicator = false;
        levelView.delaysContentTouches = false;
        levelView.contentSize = propToRect(prop: level.levelData!.propFrame!.cgRect).size
//        levelView.contentOffset = propToRect(prop: increaseRect(rect: level.levelData.propFrame, byPercentage: 0.1)).origin
        levelView.delegate = self;
        levelView.minimumZoomScale = 0.5
        levelView.maximumZoomScale = 3;
        levelView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addSubview(levelView)
        
        stageView = UIView(frame: propToRect(prop: CGRect(origin: CGPoint.zero, size: (level.levelData?.propFrame?.cgRect.size)!)))
        stageView.layer.borderColor = UIColor.black.cgColor;
        stageView.layer.borderWidth = 0;
        stageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        levelView.addSubview(stageView)
        
        
    }
    
    func increaseRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = rect.width
        let startHeight = rect.height
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
//        return CGRectInset(rect, -adjustmentWidth, -adjustmentHeight)
        return rect.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
    }
    
    func setupGestureRecognizers(){
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        //        singleTap.numberOfTapsRequired = 1
                singleTap.delegate = self;
        singleTap.minimumPressDuration = 0.3;
        singleTap.allowableMovement = propToFloat(prop: 0.7, scaleWithX: true) //pretty much maximum size well that can be created when initally created
        stageView.addGestureRecognizer(singleTap)
    }
    
    func setupLines(){
        for line in (level.levelData?.lineData)! {
            let newLine = Line(frame: levelView.frame, _startPoint: propToPoint(prop: (line.startPosition?.cgPoint)!), _startVelocity: propToVector(prop: (line.startVelocity?.cgVector)!), _startColor: line.startColor!, _startThickness: propToFloat(prop: CGFloat(line.startThickness), scaleWithX: true))
            lines.append(newLine)
//            self.stageView.layer.addSublayer(newLine)
        }
    }
    
    func setupLevelEnds(){
        
        for end in (level.levelData?.endPoints)!{
//            let outerFrame = propToRect(prop: end.outerFrame)
            let newEnd = LevelEnd(_innerFrame: propToRect(prop: (end.frame?.cgRect)!), _color: end.color!)
            endPoints.append(newEnd)
            self.stageView.addSubview(newEnd)
        }
    }
    
    func setupAntiGrvityZones(){
        for zone in (level.levelData?.antiGravityZones)!{
            let newZone = AntiGravityZone(_innerFrame: propToRect(prop: (zone.frame?.cgRect)!), _color: zone.color!)
            antiGravityZones.append(newZone)
            self.stageView.addSubview(newZone)
        }
    }
    
    func createUIButtons(){
        playResetBtn = Button(frame: propToRect(prop: CGRect(x: 0.9, y: 0, width: 0.1, height: 0.1)), text: ">", fontSize: Screen.fontSize(propFontSize: 20))
        playResetBtn.pressed = {
            if(self.paused == true){
                //play
//                self.playLevel()
//                let lines = self.getPredictedPaths();
//                print(lines.count);
//                print("");

            }else if(self.paused == false){
                //currently playing, pause and reset level
                self.paused = true;
                self.resetLines()
            }
        }
        
        homeBtn = Button(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 0.15, height: 0.1)), text: "H", fontSize: Screen.fontSize(propFontSize: 20))
        homeBtn.pressed = {
            //TODO confirmation?
            self.stop()
            self.levelViewDelegate?.level_pressMenu()
        }
        
        self.addSubview(playResetBtn);
        self.addSubview(homeBtn);
    }
    
    
    func getPredictedPaths() -> [DummyLine]{
        
        var layers : [DummyLine] = [];
        
        
        for line in lines{
            line.reset()
            line.levelCountDistance = 0;
            // different colors and thickness
            var linesForLine : [DummyLine] = [];
            
            var currentLine = DummyLine(frame: levelView.frame, _startPoint: line.startPosition, _startColor: line.lineColor, _startThickness: line.lineThickness);

            while(line.levelCountDistance < 400 && line.lineThickness >= 1 && line.madeItToEnd == false){
                
                
                if(line.lineThickness != currentLine.lineThickness || line.lineColor != currentLine.lineColor){
                    linesForLine.append(currentLine);
                    
                    currentLine = DummyLine(frame: currentLine.frame, _startPoint: currentLine.currentPoint, _startColor: line.lineColor, _startThickness: line.lineThickness);
                }
                
                
                if(line.madeItToEnd == false && line.lineThickness >= 1){
                    line.tempLineForces = CGVector.zero;
                    
                    var forces = calculateGravityForcesForLine(line: line)
                    line.tempLineForces = CGVector.zero;
                    
//                    for endView in endPoints{
//
//                        if(endView.frame.contains(stageView.convert(line.currentPoint, from: stageView))){
//
//                            if(line.lineColor == endView.color){
//                                line.levelCountTimer = Date().timeIntervalSince1970-line.levelCountTimer
//                                line.madeItToEnd = true;
//                            }
//
//                        }
//                    }
                    
                    //ANTI GRAVITY ZONES
                    //TODO doesnt work ?
                    for antiGrav in antiGravityZones {
                        if(antiGrav.frame.contains(line.currentPoint)){
                            forces = CGVector.zero
                        }
                    }
                    
                    //pemdas
                    let dV = forces / line.lineMass //accelerations
                    line.lineVelocity = line.lineVelocity + dV
                    
                    let deltaVel = line.lineVelocity!
                    
                    let pos = line.currentPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
                    line.levelCountDistance += deltaVel.length()
                    line.newLocation(p: pos)
                    
                    currentLine.newLocation(p: pos);
                    
                    //                    print("Line \(line.levelCountDistance) \(line.levelCountTimer)")
                    //handle collisions
                    
                    for gravWell in scaledGravityWells {
                        let lineCircle = Circle(center: line.currentPoint, radius: line.lineThickness/2)
                        let gravCircle = Circle(center: gravWell.corePoint, radius: gravWell.coreDiameter/2)
                        
                        let collide = lineCircle.collidesWith(circle2: gravCircle)
                        
                        if(collide && line.lineThickness >= 1){
                            line.lineThickness = line.lineThickness - 1 //TODO use by how much it's collided
                            line.updateLineThickness()
                        }
                        //                        print("C: \(line.currentPoint) \(gravWell.corePoint) \(collide)")
                    }
                    
                    
                    
                    
                    handleColorBoxesForLine(line: line)
                }
            }
            
            linesForLine.append(currentLine);
            layers.append(contentsOf: linesForLine);
        }
        
        return layers;
    }
    
    func playLevel(){
        
        self.paused = false
        self.playResetBtn.text.text = "R"
        
        for line in lines{
            line.levelCountDistance = 0
            line.levelCountTimer = Date().timeIntervalSince1970
        }
    }
    
    func setupLevelTexts(){

        currentTextsLabel = LevelTextsLabel(frame: propToRect(prop: CGRect.zero, within: self.frame), text: "", _outPos: propToPoint(prop: CGPoint(x: -1, y: 0.7)), textColor: UIColor.white, valign: VAlign.Default, _insets: true, hidden: false)
//        currentTextsLabel.font = UIFont(name: "SFProText-Light", size: Screen.fontSize(propFontSize: fontSize))

        
        currentTextsLabel.tapped = {
            self.levelTextTriggerOccured(trigger: .tap)
        }
        
        self.addSubview(currentTextsLabel)
        self.bringSubview(toFront: currentTextsLabel)
//        currentTextsLabel.animateIn()
        
        
        levelTextTriggerOccured(trigger: .start)
    }
    
    func getPropOutPosForText(propOrigin:CGPoint) -> CGPoint{
        return CGPoint(x: -1, y: propOrigin.y)
    }
    
    func levelTextTriggerOccured(trigger : LevelTextTriggers){
        let next : LevelText? = getLevelTextWithId(id: (currentText?.nextText))
        if(next != nil){
            if(next!.triggerOn == trigger){
                self.nextText(oldText: self.currentText)
            }
        }else{
            self.nextText(oldText: nil)
        }
    }
    
    var completedText : [Int] = []
    
    func nextText(oldText : LevelText?){
        
        var next : LevelText?;
        var animateOutCurrent = false;
        var animateOutTime : CGFloat = 0
        
        if(oldText != nil){
            completedText.append(Int(oldText!.id))
            next = getLevelTextWithId(id: (oldText!.nextText))
            animateOutCurrent = oldText!.animateOut
            animateOutTime = CGFloat(oldText!.animateTime)
        }else{
            next = getFirstText()
        }
        
        if(next != nil){
            if(!completedText.contains(Int(next!.id))){
                //valid new text
                currentText = next;
                
                if(animateOutCurrent){
                    currentTextsLabel.animateOut(time: animateOutTime)
                    //TODO wait for animation to complete here/put following code in completion block
                    //start block
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(animateOutTime), execute: {
                        self.updateLevelText(text: next)
                        self.currentTextsLabel.animateIn(time: CGFloat(self.currentText.animateTime))
                    })
                }else{
                    self.updateLevelText(text: next)
                    self.currentTextsLabel.animateIn(time: CGFloat(self.currentText.animateTime))
                }
            }else{
                levelTextsAllComplete() //more secure, all id's used
            }
        }else{
            levelTextsAllComplete() //less secure, can be nil b/c of read error or sth instead of actually going through all texts
        }
    }
    
    func levelTextsAllComplete(){
        currentTextsLabel.animateOut()
    }
    
    func updateLevelText(text : LevelText!){
        if(text != nil){
            //does everything but animate in/out
            let nextText = getLevelTextWithId(id: text.nextText)
            if(nextText?.triggerOn == .tap){
                currentTextsLabel.tapToContinueView.text = "Tap to continue."
//                currentTextsLabel.tapToContinueView.isHidden = false;
            }else{
                currentTextsLabel.tapToContinueView.text = ""
//                currentTextsLabel.tapToContinueView.isHidden = true;
            }
            currentTextsLabel.text = text.text
            
            let frame = propToRect(prop: (text.propFrame?.cgRect)!, within: self.frame)
            let outPos = getPropOutPosForText(propOrigin: (text.propFrame?.cgRect.origin)!)
            if(text.animateIn){
                currentTextsLabel.frame = CGRect(origin: propToPoint(prop: outPos), size: frame.size)
                currentTextsLabel.inPos = frame.origin
            }else{
                currentTextsLabel.frame = frame
                currentTextsLabel.inPos = frame.origin
            }
            
            currentTextsLabel.textColor = text.fontColor?.uiColor()
            currentTextsLabel.updateTapToContinueView()
            currentTextsLabel.font = UIFont(name: "SFProText-Light", size: Screen.fontSize(propFontSize: CGFloat(text.fontSize)))
        }
    }
    
    func getLevelTextWithId(id : Int32?) -> LevelText? {
        for text in (level.levelData?.texts)! {
            if(text.id == -1){
                return LevelText(id: -1, text: "", triggerOn: .tap, nextText: 0, animateTime: 0, animateIn: false, animateOut: false, propFrame: CGRect(x: -1, y: 0, width: 0, height: 0).rect, fontColor: Color(r: 0, g: 0, b: 0, a: 0), fontSize: 0)
            }
            if(text.id == id){
                return text
            }
        }
        return nil
    }
    
    func getFirstText() -> LevelText? {
        //make it pick a random one of the showFirsts, u know, in case OPUT (Other people use this), and prevent crash i guess
        var firstTexts : [LevelText] = []
        for text in (level.levelData?.texts)!{
            if(text.triggerOn == .start){
                firstTexts.append(text)
            }
        }
        if(firstTexts.count > 0){
            let randomIndex = Int(arc4random_uniform(UInt32(firstTexts.count))) //TODO a better way
            return firstTexts[randomIndex]
        }else{
            return nil
        }
    }
    
    func createLevelElementsFromLevel(){
        createGravityWellsFromLevel()
        createColorBoxesFromLevel()
    }
    
    func createGravityWellsFromLevel(){
        
        for gWell in (level.levelData?.gravityWells)! {
            let _ = createGravityWell(point: propToPoint(prop: (gWell.position?.cgPoint)!), core: propToFloat(prop: CGFloat(gWell.coreDiameter), scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: CGFloat(gWell.areaOfEffectDiameter), scaleWithX: true), mass: CGFloat(gWell.mass), new: false)
        }
        
    }
    
    func createColorBoxesFromLevel(){
        for cBox in (level.levelData?.colorBoxData)! {
            let _ = createColorBox(frame: propToRect(prop: (cBox.frame?.cgRect)!), rotation: CGFloat(cBox.rotation), leftCol: cBox.leftColor!, rightCol: cBox.rightColor!, backgroundColor: cBox.backgroundColor!, middlePropWidth: CGFloat(cBox.middlePropWidth))
        }
    }
    
    func resetLines(){
        for line in lines {
            line.reset()
        }
        
        self.playResetBtn.text.text = ">"
    }
    
    var longTapInital : CGPoint = CGPoint.zero;
    var currentGravityWellCreated : GravityWell!;
    var justCreatedWell : Bool!; //if a well was just created over another well, do not delete the well under it
    @objc func handleTap(_ recognizer: UIGestureRecognizer) {
        // Perform operation
        if(recognizer.state == .began){
            longTapInital = recognizer.location(in: recognizer.view)
            currentGravityWellCreated = createGravityWell(point: longTapInital, core: /*propToFloat(prop: 0.015, scaleWithX: true)*/0, areaOfEffectDiameter: /*propToFloat(prop: 0.05, scaleWithX: true)*/0, mass: 100, new: true)
//            print("Creating gravity well")
        }else if(recognizer.state == .changed){
            let p = recognizer.location(in: recognizer.view)
            var d : CGFloat = CGFloat(sqrtf(Float(pow(p.x-longTapInital.x, 2) + pow(p.y-longTapInital.y, 2))))
            
            if(d < propToFloat(prop: 0.1, scaleWithX: true)){
                d = 0
            }
            
            currentGravityWellCreated.areaOfEffectDiameter = d*2;
            currentGravityWellCreated.coreDiameter = d/2; // 1/4 ratio
            //TODO
            //currentGravityWellCreated.mass =
            currentGravityWellCreated.updateSize()
        }else if(recognizer.state == .ended){
//            print("Created well of radius \(currentGravityWellCreated.areaOfEffectDiameter/2)")
            justCreatedWell = true;
            
            if(currentGravityWellCreated.areaOfEffectDiameter/2 == 0){
                self.removeGravityWell(well: currentGravityWellCreated)
            }
        }
    }
    
    func createGravityWell(point: CGPoint, core: CGFloat, areaOfEffectDiameter: CGFloat, mass: CGFloat, new: Bool) -> GravityWell{
        let newWell = GravityWell(corePoint: point, coreDiameter: core, areaOfEffectDiameter: areaOfEffectDiameter, mass: mass)

        stageView.addSubview(newWell)
        
        newWell.touched = {
            if(self.justCreatedWell == false){
                self.removeGravityWell(well: newWell)
            }
            self.justCreatedWell = false
        }

        newWell.layer.zPosition = -100
        scaledGravityWells.append(newWell)
        
        return newWell;
    }
    
    func removeGravityWell(well : GravityWell){
        well.removeFromSuperview()
        self.scaledGravityWells.remove(at: self.scaledGravityWells.index(of: well)!)
    }
    
    func createColorBox(frame : CGRect, rotation : CGFloat, leftCol : Color, rightCol : Color, backgroundColor: Color, middlePropWidth : CGFloat) -> ColorBox{
        let newBox = ColorBox(frame: frame, _rotation: rotation, _leftColor: leftCol, _rightColor: rightCol, backgroundColor: backgroundColor, _middlePropWidth: middlePropWidth, _stageView: stageView)
        
        stageView.addSubview(newBox)
        scaledColorBoxes.append(newBox)
        
        return newBox
    }
    
//    func snapshot(){
//        let levelSave = level;
//
//        //update levelData using scaledGravityWells
//        var gravityWellData : [GravityWellData] = []
//        for scaledGravWell in scaledGravityWells {
//            gravityWellData.append(scaledGravWell.data)
//        }
//        levelSave!.levelData.gravityWells = gravityWellData;
//    }

    
    @objc func update(){
        if(paused == false){
            
            for dl in drawLines{
                dl.removeFromSuperlayer()
            }
            
            drawLines = self.getPredictedPaths();
            //                print(lines.count);
            //                print("");
            
            for dl in drawLines{
                self.stageView.layer.addSublayer(dl);
            }
            
//            for line in lines{
//                if(line.madeItToEnd == false && line.lineThickness >= 1){
//                    line.tempLineForces = CGVector.zero;
//
//                    var forces = calculateGravityForcesForLine(line: line)
//                    line.tempLineForces = CGVector.zero;
//
//                    for endView in endPoints{
////                        let newFrame : CGRect = stageView.convert(endView.frame, from:levelView)
////stageView.convert(<#T##point: CGPoint##CGPoint#>, from: <#T##UIView?#>)
//
//                        if(endView.frame.contains(stageView.convert(line.currentPoint, from: stageView))){
////                            forces = CGVector.zero;
//
//                            if(line.lineColor == endView.color){
//                                line.levelCountTimer = Date().timeIntervalSince1970-line.levelCountTimer
//                                line.madeItToEnd = true;
//                            }
//
//                        }
//                    }
//
//                    //ANTI GRAVITY ZONES
//                    //TODO doesnt work ?
//                    for antiGrav in antiGravityZones {
//                        if(antiGrav.frame.contains(line.currentPoint)){
//                            forces = CGVector.zero
//                        }
//                    }
//
//                    //pemdas
//                    let dV = forces / line.lineMass //accelerations
//                    line.lineVelocity = line.lineVelocity + dV
//
//                    let deltaVel = line.lineVelocity!
//
//                    let pos = line.currentPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
//                    line.levelCountDistance += deltaVel.length()
//                    line.newLocation(p: pos)
//
////                    print("Line \(line.levelCountDistance) \(line.levelCountTimer)")
//                    //handle collisions
//
//                    for gravWell in scaledGravityWells {
//                        let lineCircle = Circle(center: line.currentPoint, radius: line.lineThickness/2)
//                        let gravCircle = Circle(center: gravWell.corePoint, radius: gravWell.coreDiameter/2)
//
//                        let collide = lineCircle.collidesWith(circle2: gravCircle)
//
//                        if(collide && line.lineThickness >= 1){
//                            line.lineThickness = line.lineThickness - 1 //TODO use by how much it's collided
//                            line.updateLineThickness()
//                        }
////                        print("C: \(line.currentPoint) \(gravWell.corePoint) \(collide)")
//                    }
//
//
//
//
//                    handleColorBoxesForLine(line: line)
//                }
//            }
        }
        
        if(testAllLines() == true && beatLevel == false){
            paused = true;
            beatLevel = true;
            //TODO
            didBeatLevel()
        }
        
        if(isLevelDead()){
            self.paused = true;
            self.resetLines()
        }
    }
    
    
    
    func didBeatLevel(){
        func totalDistanceTravelled() -> CGFloat{
            var dist : CGFloat = 0;
            for line in lines{
                dist += line.levelCountDistance
            }
            return dist
        }
        
        func maxLineTime() -> CGFloat{
            var max : Double = 0;
            for line in lines{
                if(line.levelCountTimer > max){
                    max = line.levelCountTimer
                }
            }
            return CGFloat(max);
        }
        
        
        let dist = totalDistanceTravelled()
        let time = maxLineTime()
        
//        if(campaignLevel){
//            CampaignProgressHandler.completedLevel(levelNumber: Int(level.levelData!.levelMetadata!.levelNumber), data: CampaignProgressData(levelNumber: Int(level.levelData!.levelMetadata!.levelNumber), completed: true, locked: false, stars: 3, time: time, distance: dist))
//        }
        
        var stars : Int = 1;
        
        
        if(dist <= CGFloat((level.levelData?.levelConditions?.maxDistance)!)){
            stars += 1;
        }
        
        if(time <= CGFloat((level.levelData?.levelConditions?.maxTime)!)){
            stars += 1;
        }
        
        
        let levelProgressData = LevelProgressData(uuid: level.levelData!.levelMetadata?.levelUUID, completed: true, locked: false, stars: Int32(stars), time: Float32(time), distance: Float32(dist))
        
        if(campaignLevel){
            ProgressHandler.completedCampaignLevel(data: levelProgressData);
        }else{
            ProgressHandler.completedLevel(data: levelProgressData);
        }
        
        let levelBeat = LevelBeatView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)), _gameplayStats: LevelGameplayStats(lineDistance: dist, timePlayed: time), _campaign: campaignLevel)
        levelBeat.homePressed = {
            self.levelViewDelegate?.level_pressMenu()
        }
        levelBeat.nextLevelPressed = {
            self.levelViewDelegate?.level_nextLevel(currentLevelNumber: Int(self.level.levelData!.levelMetadata!.levelNumber))
        }
        
        //TODO animate
        self.addSubview(levelBeat)
        levelBeat.animateIn()
    }
    
    func calculateGravityForcesForLine(line : Line) -> CGVector{
        line.tempLineForces = CGVector.zero;

        //DOES CHANGING THIS line CHANGE THE LINE IN ARRAY??????
        for gravWell in scaledGravityWells{
            let distFromGravityCenter = distance(a: line.currentPoint, b: gravWell.center)
            if(distFromGravityCenter < gravWell.areaOfEffectDiameter/2){
                let f = (G * gravWell.mass * line.lineMass) / (distFromGravityCenter*distFromGravityCenter)
                
                let p2 = gravWell.center;
                let p1 = line.currentPoint!;
                let angleRad = atan2(p2.y - p1.y, p2.x - p1.x)
                
                let fx = f*cos(angleRad)
                let fy = f*sin(angleRad)
                line.tempLineForces = line.tempLineForces + (CGVector(dx: fx, dy: fy))
            }
        }
        return line.tempLineForces
    }
    
    func handleColorBoxesForLine(line : Line){
        for cBox in scaledColorBoxes {
            if(cBox.bodyView.pointInRect(locInMain: line.currentPoint, view: stageView)){
                if(cBox.pointInLeftRect(locInMain: line.currentPoint)){
                    
                    if(cBox.getStep1(line.uuid) == false){
                        //coming from outside world into left side changer
                        if(cBox.leftColor == line.lineColor){
                            cBox.setStep1(line.uuid, to: true)
                        }
                    }else if(cBox.getStep1(line.uuid) == true){
                        //coming from right side to this side
                        if(line.lineColor == cBox.rightColor){
                            cBox.setStep2(line.uuid, to: true)// = true;
                        }
                    }
                    
                    
                    if(cBox.getStep2(line.uuid) == true){
                        line.changeLineColor(to: cBox.leftColor)
                        cBox.setStep1(line.uuid, to: false)// = false;
                        cBox.setStep2(line.uuid, to: false)// = false;
                        
                    }
                }
                
                if(cBox.pointInRightRect(locInMain: line.currentPoint)){
                    
                    if(cBox.getStep1(line.uuid) == false){
                        //coming from outside world into right side changer
                        if(cBox.rightColor == line.lineColor){
                            cBox.setStep1(line.uuid, to: true)// = true;
                        }
                    }else if(cBox.getStep1(line.uuid) == true){
                        //coming from left side to this side
                        if(line.lineColor == cBox.leftColor){
                            cBox.setStep2(line.uuid, to: true)// = true;
                        }
                    }
                    
                    if(cBox.getStep2(line.uuid) == true){
                        line.changeLineColor(to: cBox.rightColor)
                        cBox.setStep1(line.uuid, to: false)// = false;
                        cBox.setStep2(line.uuid, to: false)// = false;
                    }
                }
            }else{
                cBox.setStep1(line.uuid, to: false)// = false;
                cBox.setStep2(line.uuid, to: false)// = false;
            }
        }
    }
    
    //TODO possible to combine into update function where line is looped there? the variable is being updated there...maybe not possible
    func testAllLines() -> Bool{
        var levelDone = true
        for line in lines{
            if line.madeItToEnd == false {
                levelDone = false
            }
        }
        return levelDone
    }
    
    func isLevelDead() -> Bool {
//        var levelDead = true
//
//        for line in lines{
//            if line.lineThickness > 1{//} && pointInLevel(p: line.currentPoint){
//                levelDead = false
//            }
//        }
//        return levelDead
        
        //LEVEL IS DEAD IF EVEN ONE LINE IS DEAD (ALL NEED TO MAKE IT TO END)
        var levelDead = false
        
        for line in lines{
            if line.lineThickness < 1{//} && pointInLevel(p: line.currentPoint){
                levelDead = true
            }
        }
        return false
//        return levelDead
    }
    
    //TODO doesnt work
    func pointInLevel(p : CGPoint) -> Bool{
        return stageView.frame.contains(p)
//        return (p.x >= 0 && p.x <= stageView.frame.width) && (p.y >= 0 && p.y <= stageView.frame.height)
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stageView;
    }
    
//
//    - (IBAction) renderScrollViewToImage
//    {
//        UIImage* image = nil;
//
//        UIGraphicsBeginImageContext(_scrollView.contentSize);
//        {
//            CGPoint savedContentOffset = _scrollView.contentOffset;
//            CGRect savedFrame = _scrollView.frame;
//
//            _scrollView.contentOffset = CGPointZero;
//            _scrollView.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
//
//            [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
//            image = UIGraphicsGetImageFromCurrentImageContext();
//
//            _scrollView.contentOffset = savedContentOffset;
//            _scrollView.frame = savedFrame;
//        }
//        UIGraphicsEndImageContext();
//
//        if (image != nil) {
//            [UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
//            system("open /tmp/test.png");
//        }
//    }
//
//    
//    func scrollViewToImage(){
//        var image : UIImage = nil
//        
//        UIGraphicsBeginImageContext()
//    }
//    
    func animateIn(){
        homeBtn.animateIn()
        playResetBtn.animateIn()
    }
    
    func animateOut(){
        homeBtn.animateOut()
        playResetBtn.animateOut()
    }
    
    func centerScroll(){
        let offsetX = max((levelView.bounds.width - levelView.contentSize.width) * 0.5, 0)
        let offsetY = max((levelView.bounds.height - levelView.contentSize.height) * 0.5, 0)
        self.levelView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if(changeBordersBasedOnZoom){
            if(scrollView.zoomScale <= 1){
                stageView.layer.borderWidth = 3;
            }else{
                stageView.layer.borderWidth = 0;
            }
        }
        centerScroll()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Circle {
    var center : CGPoint!
    var radius : CGFloat!
    
    func collidesWith(circle2 : Circle) -> Bool{
//        (x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
        let xx = circle2.center.x-self.center.x
        let yy = circle2.center.y-self.center.y
        let rr = circle2.radius + self.radius
        
        return ((xx*xx) + (yy*yy)) <= (rr*rr)
        
    }
}
