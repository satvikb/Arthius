//
//  CreateLevelView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol CreateLevelViewDelegate: class {
    func account_isLoggedIn() -> Bool
    func createLevelView_pressMenu()
    func createLevelView_playLv()
    func createLevelView_publishLv(title: String, description: String, thumbnail: UIImage)
}

enum ToolbarItems {
    case ColorBox
    case LineStart
    case LevelEnd
}

//like LevelView, but this time, YOU create the levels!
// TODO: USE LevelView for playing the levels that are created
class CreateLevelView : UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    weak var delegate : CreateLevelViewDelegate?;
    
    var toolbox : UIScrollView!;
    var menuBtn : Button!;
//    var publishBtn : Button!;//TODO, menu
    var playBtn : Button!;

    var levelView : LevelScrollView!;
    var stageView : UIView!;
    
    var levelData : LevelData!;
    
    var startPointView : LineStart!;
    var endPointView : UIView!;
    
    
    init(frame: CGRect, existingLevel: LevelData) {
        super.init(frame: frame)
        
        levelData = existingLevel;
        
        menuBtn = Button(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 0.1, height: 0.1)), text: "menu", fontSize: Screen.fontSize(propFontSize: 20))
        menuBtn.pressed = {
            self.showMenu()
//            self.saveLevel()
//            self.delegate?.createLevelView_pressMenu()
        }
        
//        publishBtn = Button(frame: propToRect(prop: CGRect(x: 0.1, y: 0, width: 0.2, height: 0.1)), text: "publish", fontSize: Screen.fontSize(propFontSize: 20))
//        publishBtn.pressed = {
//            self.saveLevel()
//            self.publish()
//        }
        
        playBtn = Button(frame: propToRect(prop: CGRect(x: 0.9, y: 0, width: 0.1, height: 0.1)), text: ">", fontSize: Screen.fontSize(propFontSize: 20))
        playBtn.pressed = {
            self.saveLevel()
            self.delegate?.createLevelView_playLv()
        }
        
        createLevelScrollView()
        
        toolbox = UIScrollView(frame: propToRect(prop: CGRect(x: 0, y: 0.2, width: 0.2, height: 0.7)))
        toolbox.showsHorizontalScrollIndicator = false;
//        toolbox.showsVerticalScrollIndicator = false;
        toolbox.contentSize = propToRect(prop: CGRect(x: 0, y: 0, width: 0.2, height: 1)).size
        toolbox.backgroundColor = UIColor.gray
        
        
        createStartAndEnd()
        loadCurrentLevel()
        
        addItemsToToolbox()
        
        self.addSubview(toolbox)
        self.addSubview(menuBtn)
        self.addSubview(playBtn)
//        self.addSubview(publishBtn)


//        do {
//            try Disk.save(existingLevel, to: .documents, as: USER_LEVELS_FOLDER+"/\(levelData.levelMetadata.levelUUID)")
//            let file = "\(USER_LEVELS_FOLDER)/\(levelData.levelMetadata.levelUUID)"
//            var text = "s"
//
//            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//                let fileURL = dir.appendingPathComponent(file)
//                print(fileURL.path)
//
//                //reading
//                do {
//                    text = try String(contentsOf: fileURL, encoding: .utf8)
//                    print(text)
//                }
//                catch let error as NSError{/* error handling here */
//                    print("read error "+error.localizedDescription)
//                }
//            }
//        } catch let error as NSError {
//            print("""
//                NO SAVE TEST
//                Domain: \(error.domain)
//                Code: \(error.code)
//                Description: \(error.localizedDescription)
//                Failure Reason: \(error.localizedFailureReason ?? "")
//                Suggestions: \(error.localizedRecoverySuggestion ?? "")
//                """)
//        }
    }
    
    func showMenu(){
        let levelView = LevelCreateMenu(frame: self.frame)
        levelView.animateIn()
        
        levelView.menuPressed = {
            let levelLeaveConfirmation = LevelLeaveConfirmation(frame: self.frame, confirmationText: "Save changes?", confirmText: "Yes", denyText:"No")
            levelLeaveConfirmation.animateIn()
            
            levelLeaveConfirmation.confimed = {
                self.saveLevel()
                self.delegate?.createLevelView_pressMenu()
            }
            
            levelLeaveConfirmation.denied = {
                self.delegate?.createLevelView_pressMenu()
            }
            
            levelLeaveConfirmation.cancelled = {
                levelLeaveConfirmation.removeFromSuperview()
            }
            
            self.addSubview(levelLeaveConfirmation)
        }
        
        levelView.resumePressed = {
            levelView.removeFromSuperview()
        }
        
        levelView.publishPressed = {
            self.saveLevel()
            
            if(self.delegate?.account_isLoggedIn())!{
                self.publishView()
            }else{
                print("Not signed in! Can't show publish view")
            }
        }
        
        self.addSubview(levelView)
    }
    
    static func BlankLevel() -> LevelData{
        return LevelData(levelMetadata: LevelMetadata(levelUUID: UUID().uuidString, levelNumber: 0, levelName: "Untitled", levelVersion: "0", levelAuthor: "Unknown"), texts: [/*LevelText(id: 0, showFirst: true, text: "Welcome to GAME", triggerOn: .None, showNext: 0)*/], propFrame: CGRect(x: 0, y: 0, width: 1, height: 1), endPoints: [EndData(outerFrame: CGRect(x: 0.7, y: 0.7, width: 0.1, height: 0.1), coreFrame: CGRect(x: 0.4, y: 0.4, width: 0.2, height: 0.2), endColor: Color(r: 0, g: 0, b: 0, a: 1))], lineData: [LineData(startPosition: CGPoint(x: 0.2, y: 0.2), startVelocity: CGVector(dx: 0, dy: 0.0025), startColor: Color(r: 0.2, g: 0.1, b: 1, a: 1))], gravityWells: [], colorBoxData: [ColorBoxData(frame: CGRect(x: 0.45, y: 0.4, width: 0.1, height: 0.1), rotation: 0, box: false, leftColor: Color(r: 0.2, g: 0.1, b: 1, a: 1), rightColor: Color(r: 0, g: 0, b: 0, a: 1), backgroundColor: Color(r: 0.2, g: 0.2, b: 0.2, a: 1), middlePropWidth: 0.7)], rockData: [], speedBoostData: [])
    }
    
    func publishView(){
        
        let publishView = PublishLevelView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1)), level: levelData)
        
        publishView.publishBtnPressed = { (title : String, description : String, thumbnail: UIImage) in
            self.delegate?.createLevelView_publishLv(title: title, description: description, thumbnail: thumbnail)
        }
        
        publishView.cancelled = {
            publishView.removeFromSuperview()
        }
        
        self.addSubview(publishView)
        publishView.animateIn()
    }
    
    func saveLevel(){
        do {
            try Disk.save(levelData, to: .documents, as: "\(File.getFolderForLevelType(type: .UserMade))/\(levelData.levelMetadata.levelUUID).\(File.levelExtensionForType(type: .UserMade))")
        }catch let error as NSError{
            print("Error saving user made level \(error.localizedDescription)")
        }
    }
    
    func createLevelScrollView(){
        levelView = LevelScrollView(frame: UIScreen.main.bounds)
        levelView.isUserInteractionEnabled = true;
        levelView.bounces = false;
        levelView.showsVerticalScrollIndicator = false;
        levelView.showsHorizontalScrollIndicator = false;
        levelView.delaysContentTouches = false;

        levelView.delegate = self;
        levelView.minimumZoomScale = 0.5
        levelView.maximumZoomScale = 3;
        levelView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        levelView.panGestureRecognizer.delegate = self
        self.addSubview(levelView)
        
        stageView = UIView(frame: propToRect(prop: CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1))))
        stageView.layer.borderColor = UIColor.black.cgColor;
        stageView.layer.borderWidth = 3;
        stageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        levelView.addSubview(stageView)
    }
    
    func loadCurrentLevel(){
        //load all the current items already in data
        for cBox in levelData.colorBoxData {
            addColorBoxToView(d: cBox)
        }
    }
    
    func createStartAndEnd(){
        //show simple rectangle for now for start points
        
        for lineData in levelData.lineData {
            self.addStartLineToView(d: lineData)
            
        }
        
        
        //TODO: MULTIPLE ENDS? yes ofc, allows for one end of each colors for ex.

        //show the end frame
        endPointView = UIView(frame: propToRect(prop: levelData.endPoints[0].outerFrame))
        endPointView.backgroundColor = UIColor.black;
        stageView.addSubview(endPointView);
    }
    
    func addItemsToToolbox(){
        //TODO: make box
        let colorChangeBtn = ToolboxButton(frame: propToRect(prop: CGRect(x: 0, y: 0.1, width: 1, height: 0.1), within: toolbox.frame))
        colorChangeBtn.backgroundColor = UIColor.yellow;
        colorChangeBtn.pressed = {
            let colorBoxData : ColorBoxData = ColorBoxData(frame: CGRect(x: 0.45, y: 0.45, width: 0.1, height: 0.1), rotation: 0, box: false, leftColor: self.levelData.lineData[0].startColor, rightColor: self.levelData.lineData[0].startColor, backgroundColor: Color(r: 0.2, g: 0.2, b: 0.2, a: 1), middlePropWidth: 0.2)
            self.addColorBoxToView(d: colorBoxData)
            self.levelData.colorBoxData.append(colorBoxData)

        }
        toolbox.addSubview(colorChangeBtn)
        
        
        let lineStartBtn = ToolboxButton(frame: propToRect(prop: CGRect(x: 0, y: 0.3, width: 1, height: 0.1), within: toolbox.frame))
        lineStartBtn.backgroundColor = UIColor.yellow;
        lineStartBtn.pressed = {
            let startLineData : LineData = LineData(startPosition: CGPoint(x: 0.5, y: 0.5), startVelocity: CGVector(dx: 0.001, dy: 0), startColor: Color(r: 0, g: 0, b: 0, a: 1))
            self.addStartLineToView(d: startLineData)
            self.levelData.lineData.append(startLineData)
            
        }
        toolbox.addSubview(lineStartBtn)
    }
    
    func addColorBoxToView(d : ColorBoxData){
        var data = d
        let colorBox = ColorBox(frame: propToRect(prop: data.frame), _rotation: data.rotation, box: data.box, _leftColor: data.leftColor, _rightColor: data.rightColor, backgroundColor: data.backgroundColor, _middlePropWidth: data.middlePropWidth, _stageView: stageView, _editable: true)
        
        colorBox.frameChanged = {
            self.levelData.colorBoxData.remove(at: self.levelData.colorBoxData.index(of: data)!)
            data.frame = self.rectToProp(rect: colorBox.bodyView.frame)
            self.levelData.colorBoxData.append(data)
        }
        
        colorBox.frameChangeKnob.panGesture.delegate = self
        stageView.addSubview(colorBox)
    }
    
    func addStartLineToView(d : LineData){
        var data = d
        let maxPropStartVeclocity : CGFloat = 0.002 //TODO per level, global?

        let lineStart = LineStart(f: propToRect(prop: CGRect(x: d.startPosition.x, y: d.startPosition.y, width: 0.1, height: 0)), _startVelocity: d.startVelocity, _lineColor: d.startColor, _maxPropStartVelocity: CGVector(dx: maxPropStartVeclocity, dy: maxPropStartVeclocity))
        
        lineStart.frameChanged = {
            self.levelData.lineData.remove(at: self.levelData.lineData.index(of: data)!)
            data.startPosition = self.pointToProp(point: lineStart.center)
            data.startVelocity = lineStart.getCurrentKnobVectorNormalized()*lineStart.maxPropStartVelocity*CGVector(dx: 1, dy: UIScreen.main.bounds.width/UIScreen.main.bounds.height)
//            print(data.startVelocity, data.startVelocity/CGVector(dx: 1, dy: UIScreen.main.bounds.width/UIScreen.main.bounds.height))
            self.levelData.lineData.append(data)
        }
        
        lineStart.frameChangeKnob.panGesture.delegate = self
        stageView.addSubview(lineStart)
    }
    
    func animateIn(){
        menuBtn.animateIn()
        playBtn.animateIn()
//        publishBtn.animateIn()
    }
    
    func animateOut(){
        menuBtn.animateOut()
        playBtn.animateOut()
//        publishBtn.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stageView;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    
    func centerScroll(){
        let offsetX = max((levelView.bounds.width - levelView.contentSize.width) * 0.5, 0)
        let offsetY = max((levelView.bounds.height - levelView.contentSize.height) * 0.5, 0)
        self.levelView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScroll()
    }
}

class ToolboxButton : UIView {
    
    var pressed = {}
    var heldDown = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heldDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count > 0){
            if(heldDown == true && touchInBtn(point: touches.first!.location(in: self.superview))){
                heldDown = false
                pressed()
            }
        }
    }
    
    func touchInBtn(point : CGPoint) -> Bool{
        let f = self.frame
        
        if(point.x > f.origin.x && point.x < f.origin.x+f.size.width && point.y > f.origin.y && point.y < f.origin.y+f.size.height){
            return true
        }
        return false
    }
}

class LevelCreateMenu : UIView {
    
    var resumePressed = {}
    var menuPressed = {}
    var publishPressed = {}
    
    var backgroundView : UIView!;
    var resumeButton : Button!;
    var publishButton : Button!;
    var menuButton : Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        backgroundView = UIView(frame: propToRect(prop: CGRect(x: 0.25, y: 0.3, width: 0.5, height: 0.5), within: self.frame))
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = backgroundView.frame.height/10
        self.addSubview(backgroundView)

        
        
        resumeButton = Button(frame: propToRect(prop: CGRect(x: 0.05, y: 0.075, width: 0.9, height: 0.25), within: backgroundView.frame), text: "resume", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.05, width: 0, height: 0), within: self.frame).origin)
        resumeButton.layer.cornerRadius = resumeButton.frame.height/10
        resumeButton.pressed = {
            self.resumePressed()
        }
        backgroundView.addSubview(resumeButton)
        
        publishButton = Button(frame: propToRect(prop: CGRect(x: 0.05, y: 0.375, width: 0.9, height: 0.25), within: backgroundView.frame), text: "publish", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.05, width: 0, height: 0), within: self.frame).origin)
        publishButton.layer.cornerRadius = resumeButton.frame.height/10
        publishButton.pressed = {
            self.publishPressed()
        }
        backgroundView.addSubview(publishButton)
        
        menuButton = Button(frame: propToRect(prop: CGRect(x: 0.05, y: 0.675, width: 0.9, height: 0.25), within: backgroundView.frame), text: "home", fontSize: Screen.fontSize(propFontSize: 30), outPos: propToRect(prop: CGRect(x: -1, y: 0.05, width: 0, height: 0), within: self.frame).origin)
        menuButton.backgroundColor = UIColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 1)
        menuButton.layer.cornerRadius = resumeButton.frame.height/10

        menuButton.pressed = {
            self.menuPressed()
        }
        backgroundView.addSubview(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resumePressed()
    }
    
    func animateIn(){
        resumeButton.animateIn()
        publishButton.animateIn()
        menuButton.animateIn()
    }
    
    func animateOut(){
        resumeButton.animateOut()
        publishButton.animateOut()
        menuButton.animateOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
