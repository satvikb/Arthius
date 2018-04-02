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
    func level_nextLevel()
}

class Line : CAShapeLayer{
    
    var startPosition : CGPoint!;
    var startVelocity : CGVector!;
    var startColor : Color!;
    
    var currentPoint: CGPoint!
    var linePath : UIBezierPath!;
//    var lineShape : CAShapeLayer!;
    var lineVelocity: CGVector!;
    var lineColor : Color!;
    
    var lineMass : CGFloat = 1; //no effect for now?
    var tempLineForces : CGVector! = CGVector.zero;

    var madeItToEnd : Bool = false;
    
//    var startView : UIView!; //For editable
    
    
    //TODO: frame: should be just the screen bounds, or should it be level bounds (sizes bigger than screen)?
    init(frame: CGRect, _startPoint : CGPoint, _startVelocity : CGVector, _startColor : Color) {
        startPosition = _startPoint;
        startVelocity = _startVelocity;
        startColor = _startColor;
        
        lineColor = startColor;
        currentPoint = startPosition;
        lineVelocity = startVelocity;
        linePath = UIBezierPath();

        super.init()
        
        linePath.move(to: startPosition)
        self.frame = frame;
        self.path = linePath.cgPath;
        self.lineCap = kCALineCapRound;
        self.fillColor = UIColor.clear.cgColor;
        self.lineWidth = 10;
        updateStrokeColor()
        self.zPosition = 100;
        
        reset()
    }
    
    func reset(){
        currentPoint = startPosition;
        lineVelocity = startVelocity;
        lineColor = startColor;
        
        linePath = UIBezierPath();
        linePath.move(to: currentPoint)
        path = nil;
        updateStrokeColor()
    }
    
    func newLocation(p: CGPoint){
        linePath.addLine(to: p);
        path = linePath.cgPath;
        didChangeValue(forKey: "path")
        currentPoint = p;
    }
    
    func changeLineColor(to: Color){
        lineColor = to;
        updateStrokeColor()
    }
    
    func updateStrokeColor(){
        self.strokeColor = ColorBox.ColorToUIColor(col: lineColor).cgColor
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
    var innerView : UIView!;
    var color : Color!;
    
    var endView : UIView!; //For editable
    
    init(_outerFrame : CGRect, _innerFrame : CGRect, _color : Color) {
        super.init(frame: _outerFrame)
        color = _color
        
        self.backgroundColor = UIColor.black
        
        innerView = UIView(frame: _innerFrame)
        innerView.backgroundColor = ColorBox.ColorToUIColor(col: _color)
        
        self.addSubview(innerView)
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
    var endPoints : [LevelEnd] = []
    
    let G : CGFloat = 1;
    
    var playResetBtn : Button!;
    var homeBtn : Button!;

    var beatLevel : Bool = false;
    
    //Create scaled arrays to store the level elements that are scaled up to the current device size. TODO: Do this for all the other level elements.
    //This is created because the GravityWellData in LevelData stores the proportional sizes. Instead of converting from prop to real in the update look, it's easier to just store the scaled wells as well.
    //This is what is used for calculations, GravityWellData is what is used to save.
    var scaledGravityWells : [GravityWell] = []
    var scaledColorBoxes : [ColorBox] = []
    
    var displayLink : CADisplayLink!
    var paused = true;
    
    
    var currentTextsLabel : LevelTextsLabel!;
    var currentText : LevelText!;
//    var currentTrigger : LevelTextTriggers!; // Within currentText
    
    var changeBordersBasedOnZoom : Bool = true

    init(_level: Level, _parentView: View){
        level = _level;
        parentView = _parentView;
        super.init(frame: UIScreen.main.bounds)

        self.backgroundColor = UIColor.white
        
        
        setupLevelView()
        setupLines()
        setupLevelEnds()
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
        levelView.contentSize = propToRect(prop: level.levelData.propFrame).size
//        levelView.contentOffset = propToRect(prop: increaseRect(rect: level.levelData.propFrame, byPercentage: 0.1)).origin
        levelView.delegate = self;
        levelView.minimumZoomScale = 0.5
        levelView.maximumZoomScale = 3;
        levelView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addSubview(levelView)
        
        stageView = UIView(frame: propToRect(prop: CGRect(origin: CGPoint.zero, size: level.levelData.propFrame.size)))
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
        for line in level.levelData.lineData {
            let newLine = Line(frame: levelView.frame, _startPoint: propToPoint(prop: line.startPosition), _startVelocity: propToVector(prop: line.startVelocity), _startColor: line.startColor)
            lines.append(newLine)
            self.stageView.layer.addSublayer(newLine)
            
            
        }
        
    }
    
    func setupLevelEnds(){
        
        for end in level.levelData.endPoints{
            let outerFrame = propToRect(prop: end.outerFrame)
            let newEnd = LevelEnd(_outerFrame: outerFrame, _innerFrame: propToRect(prop: end.coreFrame, within: outerFrame), _color: end.endColor)
            endPoints.append(newEnd)
            self.stageView.addSubview(newEnd)
        }
        
//        let endRect = UIView(frame: endRectScaled)
//        endRect.backgroundColor = ColorBox.ColorToUIColor(col: level.levelData.endColor)
//        self.stageView.addSubview(endRect)
    }
    
    func createUIButtons(){
        playResetBtn = Button(frame: propToRect(prop: CGRect(x: 0.9, y: 0, width: 0.1, height: 0.1)), text: ">", fontSize: Screen.fontSize(propFontSize: 20))
        playResetBtn.pressed = {
            if(self.paused == true){
                //play
                self.paused = false
                self.playResetBtn.text.text = "R"
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
    
    func setupLevelTexts(){
        
//        var startText : String = ""
//        var startHidden : Bool = true;
//        var startPropFrame : CGRect = CGRect.zero
//        var textColor : UIColor = UIColor.clear;
//        var fontSize : CGFloat = 0;
        
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
        let next : LevelText? = getLevelTextWithId(id: currentText?.nextText)
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
            completedText.append(oldText!.id)
            next = getLevelTextWithId(id: oldText!.nextText)
            animateOutCurrent = oldText!.animateOut
            animateOutTime = oldText!.animateTime
        }else{
            next = getFirstText()
        }
        
        if(next != nil){
            if(!completedText.contains(next!.id)){
                //valid new text
                currentText = next;
                
                if(animateOutCurrent){
                    currentTextsLabel.animateOut(time: animateOutTime)
                    //TODO wait for animation to complete here/put following code in completion block
                    //start block
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(animateOutTime), execute: {
                        self.updateLevelText(text: next)
                        self.currentTextsLabel.animateIn(time: self.currentText.animateTime)
                    })
                }else{
                    self.updateLevelText(text: next)
                    self.currentTextsLabel.animateIn(time: self.currentText.animateTime)
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
            
            let frame = propToRect(prop: text.propFrame, within: self.frame)
            let outPos = getPropOutPosForText(propOrigin: text.propFrame.origin)
            if(text.animateIn){
                currentTextsLabel.frame = CGRect(origin: propToPoint(prop: outPos), size: frame.size)
                currentTextsLabel.inPos = frame.origin
            }else{
                currentTextsLabel.frame = frame
                currentTextsLabel.inPos = frame.origin
            }
            
            currentTextsLabel.textColor = text.fontColor.uiColor()
            currentTextsLabel.updateTapToContinueView()
            currentTextsLabel.font = UIFont(name: "SFProText-Light", size: Screen.fontSize(propFontSize: text.fontSize))
        }
    }
    
    func getLevelTextWithId(id : Int?) -> LevelText? {
        for text in level.levelData.texts {
            if(text.id == id){
                return text
            }
        }
        return nil
    }
    
    func getFirstText() -> LevelText? {
        //make it pick a random one of the showFirsts, u know, in case OPUT (Other people use this), and prevent crash i guess
        var firstTexts : [LevelText] = []
        for text in level.levelData.texts{
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
        
        for gWell in level.levelData.gravityWells {
            let _ = createGravityWell(point: propToPoint(prop: gWell.position), core: propToFloat(prop: gWell.coreDiameter, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: gWell.areaOfEffectDiameter, scaleWithX: true), mass: gWell.mass, new: false)
        }
        
    }
    
    func createColorBoxesFromLevel(){
        for cBox in level.levelData.colorBoxData {
            let _ = createColorBox(frame: propToRect(prop: cBox.frame), rotation: cBox.rotation, box: cBox.box, leftCol: cBox.leftColor, rightCol: cBox.rightColor, backgroundColor: cBox.backgroundColor, middlePropWidth: cBox.middlePropWidth)
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
            currentGravityWellCreated = createGravityWell(point: longTapInital, core: propToFloat(prop: 0.015, scaleWithX: true), areaOfEffectDiameter: propToFloat(prop: 0.05, scaleWithX: true), mass: 100, new: true)
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
    
    func createColorBox(frame : CGRect, rotation : CGFloat, box : Bool, leftCol : Color, rightCol : Color, backgroundColor: Color, middlePropWidth : CGFloat) -> ColorBox{
        let newBox = ColorBox(frame: frame, _rotation: rotation, box: box, _leftColor: leftCol, _rightColor: rightCol, backgroundColor: backgroundColor, _middlePropWidth: middlePropWidth, _stageView: stageView)
        
        stageView.addSubview(newBox)
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

    
    @objc func update(){
        if(paused == false){
            
            for line in lines{
                if(line.madeItToEnd == false){
                    line.tempLineForces = CGVector.zero;
                    
                    for endView in endPoints{
                        
                        var forces = calculateGravityForcesForLine(line: line)
                        line.tempLineForces = CGVector.zero;

                        if(endView.frame.contains(line.currentPoint)){
                            forces = CGVector.zero;

//                            [subview convertPoint:pointInSuperview fromView:superview];
                            //TODO compatibility test conversion
//                            let endViewPos = endView.convert(line.currentPoint, from: stageView)
//                            let innerViewPos = endView.innerView.convert(endViewPos, from: endView)
                            let innerFrame : CGRect = stageView.convert(endView.innerView.frame, from:endView)

//                            if(endView.innerView.frame.contains(innerViewPos)){
                            if(innerFrame.contains(line.currentPoint)){
                                if(line.lineColor == endView.color){
                                    line.madeItToEnd = true;
                                }
                            }
                        }
                        
                        
                        //pemdas
                        let dV = forces / line.lineMass
                        line.lineVelocity = line.lineVelocity + dV
                        
                        let deltaVel = line.lineVelocity!
                        let pos = line.currentPoint + CGPoint(x: deltaVel.dx, y: deltaVel.dy);
                        line.newLocation(p: pos)
                    }
                    
                    //handle collisions
                    
                    
                    
                    
                    
                    
                    handleColorBoxesForLine(line: line)
                }
            }
        }
        
        if(testAllLines() == true && beatLevel == false){
            paused = true;
            beatLevel = true;
            //TODO
            didBeatLevel()
        }
    }
    
    func didBeatLevel(){
        let levelBeat = LevelBeatView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)), _gameplayStats: LevelGameplayStats(lineDistance: 0, timePlayed: 0))
        levelBeat.homePressed = {
            self.levelViewDelegate?.level_pressMenu()
        }
        levelBeat.nextLevelPressed = {
            self.levelViewDelegate?.level_nextLevel()
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
            if(cBox.bodyView.pointInRect(locInMain: line.currentPoint)){
                if(cBox.pointInLeftRect(locInMain: line.currentPoint)){
                    
                    if(cBox.step1 == false){
                        //coming from outside world into left side changer
                        if(cBox.leftColor == line.lineColor){
                            cBox.step1 = true;
                        }
                    }else if(cBox.step1 == true){
                        //coming from right side to this side
                        if(line.lineColor == cBox.rightColor){
                            cBox.step2 = true;
                        }
                    }
                    
                    
                    if(cBox.step2 == true){
                        line.changeLineColor(to: cBox.leftColor)
                        cBox.step1 = false;
                        cBox.step2 = false;
                    }
                }
                
                if(cBox.pointInRightRect(locInMain: line.currentPoint)){
                    
                    if(cBox.step1 == false){
                        //coming from outside world into right side changer
                        if(cBox.rightColor == line.lineColor){
                            cBox.step1 = true;
                        }
                    }else if(cBox.step1 == true){
                        //coming from left side to this side
                        if(line.lineColor == cBox.leftColor){
                            cBox.step2 = true;
                        }
                    }
                    
                    if(cBox.step2 == true){
                        line.changeLineColor(to: cBox.rightColor)
                        cBox.step1 = false;
                        cBox.step2 = false;
                    }
                }
            }else{
                cBox.step1 = false;
                cBox.step2 = false;
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
