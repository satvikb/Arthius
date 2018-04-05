//
//  GlobalLevelSelectView.swift
//  Arthius
//
//  Created by Satvik Borra on 4/2/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

struct LevelQuery {
    var userId : String?
    var levelTitle : String?
    var minimumDownloads : Int?
    var maxResults : Int?
}

//level data that is shown is GLS but actual download of level is not needed
struct GLSLevelData {
    var title : String
    var creatorId : String
    var levelUUID : String
    var description : String
    //etc
}

protocol GlobalLevelSelectViewDelegate: class {
    func globalLevelSelect_pressBack()
//    func globalLevelSelect_getLevels(query : LevelQuery) -> [GLSLevelData]
    func globalLevelSelect_getLevels(query: LevelQuery, completion: @escaping ([GLSLevelData]) -> Void)
    func globalLevelSelect_pressLevel(level:LevelData)
}

class GlobalLevelSelectView : UIView {
    
    weak var globalLevelSelectDelegate : GlobalLevelSelectViewDelegate?
    var titleLabel : Label!;
    var backButton : Button!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true;
     
        
        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.25, y: 0.05, width: 0.65, height: 0.15)), text: "GLS", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), textColor: UIColor.black, valign: .Bottom, _insets: false)
        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .right
        self.addSubview(titleLabel)
        
        backButton = Button(frame: propToRect(prop: CGRect(x: 0, y: 0.05, width: 0.2, height: 0.15)), text: "back")
        backButton.pressed = {
            self.globalLevelSelectDelegate?.globalLevelSelect_pressBack()
        }
        self.addSubview(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLevels(query : LevelQuery){
        //TODO get query from UI
        
        //get all queried levels from firebase
        globalLevelSelectDelegate?.globalLevelSelect_getLevels(query: query, completion: {(levelData : [GLSLevelData]) in
            
            print("Got levels: \(String(describing: levelData.count))")

            //TODO create/update level selector
            
        })
        
    }
    
    func animateIn(){
        titleLabel.animateIn()
        backButton.animateIn()
        
        //TODO
        self.loadLevels(query: LevelQuery(userId: nil, levelTitle: nil, minimumDownloads: nil, maxResults: nil))
    }

    func animateOut(){
        titleLabel.animateOut()
        backButton.animateOut()
    }
}



//class CampaignLevelSelectView: UIView, LevelSelectorDelegate {
//
//    weak var campaignLevelSelectDelegate:CampaignLevelSelectorViewDelegate?
//    var titleLabel : Label!;
//
//    var levels : [LevelData] = []
//    //    var levelTiles : [LevelSelectTile] = []
//
//    var levelSelectScroll : LevelSelector!;
//
//    var backButton : Button!;
//
//    init(startPosition: CGPoint){
//        super.init(frame: CGRect(origin: startPosition, size: UIScreen.main.bounds.size))//CGRect.propToRect(prop: _level.levelData.propFrame, parentRect: UIScreen.main.bounds));
//        self.isUserInteractionEnabled = true;
//
//        titleLabel = Label(frame: propToRect(prop: CGRect(x: 0.25, y: 0.05, width: 0.65, height: 0.15)), text: "Campaign", _outPos: propToPoint(prop: CGPoint(x: 1, y: 0.05)), textColor: UIColor.black, valign: .Bottom, _insets: false)
//        titleLabel.font = UIFont(name: "SFProText-Heavy", size: Screen.fontSize(propFontSize: 70))
//        titleLabel.adjustsFontSizeToFitWidth = true
//        titleLabel.textAlignment = .right
//        self.addSubview(titleLabel)
//
//        backButton = Button(frame: propToRect(prop: CGRect(x: 0, y: 0.05, width: 0.2, height: 0.15)), text: "back")
//        backButton.pressed = {
//            self.campaignLevelSelectDelegate?.campaignLevelSelect_pressBack()
//        }
//        self.addSubview(backButton)
//
//        loadLevels()
//    }
//
//    func loadLevels(){
//        // load all .gws files from campaignlevels directory
//        // loading async?
//
//        levels = File.getAllLevels(type: .Campaign)
//
//
//        levelSelectScroll = LevelSelector(frame: propToRect(prop: CGRect(x: 0, y: 0.25, width: 1, height: 0.75)), xTiles: 3, yTiles: 3, levels: levels)
//        levelSelectScroll.isUserInteractionEnabled = true;
//        levelSelectScroll.levelSelectorDelegate = self
//        self.addSubview(levelSelectScroll)
//    }
//
//    func animateIn(time: CGFloat){
//        titleLabel.animateIn(time: time)
//        backButton.animateIn()
//    }
//
//    func animateOut(time : CGFloat){
//        titleLabel.animateOut(time: time)
//        backButton.animateOut()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func levelSelector_pressedLevel(level: LevelData) {
//        self.campaignLevelSelectDelegate?.campaignLevelSelect_pressLevel(level: level)
//    }
//}
