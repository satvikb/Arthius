//
//  CreateLevelView.swift
//  Arthius
//
//  Created by Satvik Borra on 3/24/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol CreateLevelViewDelegate: class {
    func createLevelView_pressBack()
}

enum ToolbarItems {
    case ColorBox
}

//like LevelView, but this time, YOU create the levels!
// TODO: USE LevelView for playing the levels that are created
class CreateLevelView : UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    weak var delegate : CreateLevelViewDelegate?;
    var toolbox : UIScrollView!;
    var backBtn : Button!;
    
    var levelView : LevelScrollView!;
    var stageView : UIView!;
    
    var levelData : LevelData!;
    
    init(frame: CGRect, existingLevel: LevelData) {
        super.init(frame: frame)
        
        levelData = existingLevel;
        
        backBtn = Button(propFrame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1), text: "back", fontSize: Screen.fontSize(propFontSize: 20))
        backBtn.pressed = {
            self.saveLevel()
            self.delegate?.createLevelView_pressBack()
        }
        
        createLevelScrollView()
        
        toolbox = UIScrollView(frame: propToRect(prop: CGRect(x: 0, y: 0.1, width: 0.2, height: 0.8)))
        toolbox.showsHorizontalScrollIndicator = false;
//        toolbox.showsVerticalScrollIndicator = false;
        toolbox.contentSize = propToRect(prop: CGRect(x: 0, y: 0, width: 0.2, height: 1)).size
        toolbox.backgroundColor = UIColor.gray
        
        
        createStartAndEnd()
        addItemsToToolbox()
        
        self.addSubview(toolbox)
        self.addSubview(backBtn)
        

    }
    
    static func BlankLevel() -> LevelData{
        return LevelData(levelMetadata: LevelMetadata(levelUUID: UUID().uuidString, levelNumber: 0, levelName: "Untitled", levelVersion: "0", levelAuthor: "Unknown"), propFrame: CGRect(x: 0, y: 0, width: 1, height: 1), startPosition: CGPoint(x: 0, y: 0.5), endPosition: CGRect(x: 0.9, y: 0.45, width: 0.1, height: 0.1), startVelocity: CGVector(dx: 5, dy: 0), startColor: Color(r: 0, g: 0.2, b: 1, a: 1), endColor: Color(r: 0, g: 0.2, b: 1, a: 1), gravityWells: [], colorBoxData: [], rockData: [], speedBoostData: [])

    }
    
    func saveLevel(){
        do {
            try Disk.save(levelData, to: .documents, as: "\(File.getFolderForLevelType(type: .UserMade))/\(levelData.levelMetadata.levelUUID).gws")
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
//        levelView.contentSize = propToRect(prop: level.levelData.propFrame).size
        //        levelView.contentOffset = propToRect(prop: increaseRect(rect: level.levelData.propFrame, byPercentage: 0.1)).origin
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
            createColorbox(d: cBox)
//            let cBoxView = ColorBox(frame: cBox.frame, rotation: cBox.rotation, box: cBox.box, _leftColor: cBox.leftColor, _rightColor: cBox.rightColor, backgroundColor: cBox.backgroundColor, _middlePropWidth: cBox.middlePropWidth, _stageView: stageView)
        }
    }
    
    func createStartAndEnd(){
        //show simple rectangle for now for start points
        
        //show the end frame
        
    }
    
    func addItemsToToolbox(){
        //TODO: make box
        let colorChangeBtn = ToolboxButton(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.1), within: toolbox.frame))
        colorChangeBtn.backgroundColor = UIColor.yellow;
        colorChangeBtn.pressed = {
            self.createColorbox(d: ColorBoxData(frame: CGRect(x: 0.45, y: 0.45, width: 0.1, height: 0.1), rotation: 0, box: false, leftColor: self.levelData.startColor, rightColor: self.levelData.startColor, backgroundColor: Color(r: 0.2, g: 0.2, b: 0.2, a: 1), middlePropWidth: 0.2))
        }
        toolbox.addSubview(colorChangeBtn)
    }
    
    func createColorbox(d : ColorBoxData){
        var data = d
        let colorBox = ColorBox(frame: propToRect(prop: data.frame), rotation: data.rotation, box: data.box, _leftColor: data.leftColor, _rightColor: data.rightColor, backgroundColor: data.backgroundColor, _middlePropWidth: data.middlePropWidth, _stageView: stageView, _editable: true)
        
        //before the change, find the element in level data
        //delete element
        //add new changed element
        colorBox.frameChanged = {
            self.levelData.colorBoxData.remove(at: self.levelData.colorBoxData.index(of: data)!)
//            print("\(data.frame) \(String(describing: self.levelData.colorBoxData.index(of: data)))")
            data.frame = self.rectToProp(rect: colorBox.frame)
            self.levelData.colorBoxData.append(data)
//            print("\(data.frame) \(String(describing: self.levelData.colorBoxData.index(of: data)))")
//            print("")
        }
        
//        colorBox.panGesture.delegate = self;
        colorBox.frameChangeKnob.panGesture.delegate = self
        
        levelData.colorBoxData.append(data)
        stageView.addSubview(colorBox)
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
        //        self.levelView.center = CGPoint(x: levelView.contentSize.width * 0.5 + offsetX, y: levelView.contentSize.height * 0.5 + offsetY)
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
        //            print("end \(touches.count) \(heldDown) \(touchInBtn(point: (touches.first?.location(in: self.superview))!))")
        if(touches.count > 0){
            if(heldDown == true && touchInBtn(point: touches.first!.location(in: self.superview))){
                heldDown = false
                pressed()
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
    
   
}
