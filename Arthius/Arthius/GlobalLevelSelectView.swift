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
    var downloads : Int
    //etc
}

protocol GlobalLevelSelectViewDelegate: class {
    func globalLevelSelect_pressBack()
//    func globalLevelSelect_getLevels(query : LevelQuery) -> [GLSLevelData]
    func globalLevelSelect_getLevels(query: LevelQuery, completion: @escaping ([GLSLevelData]) -> Void)
    func globalLevelSelect_pressLevel(level:GLSLevelData)
    func globalLevelSelect_getThumbnail(uuid : String, completion: @escaping (_ img : UIImage) -> Void)
}

class GlobalLevelSelectView : UIView, GLSSelectorDelegate {
    
    weak var globalLevelSelectDelegate : GlobalLevelSelectViewDelegate?
    var titleLabel : Label!;
    var backButton : Button!;
    
    var levelSelector : GLSLevelSelector!;
    
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
        
        levelSelector = GLSLevelSelector(frame: propToRect(prop: CGRect(x: 0, y: 0.25, width: 1, height: 0.75)), xTiles: 3, yTiles: 3, levels: [])
        levelSelector.isUserInteractionEnabled = true;
        levelSelector.glsSelectorDelegate = self
        self.addSubview(levelSelector)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLevels(query : LevelQuery){
        //TODO get query from UI
        
        print("Getting levels")
        //get all queried levels from firebase
        globalLevelSelectDelegate?.globalLevelSelect_getLevels(query: query, completion: {(levelData : [GLSLevelData]) in
            
            print("Got levels: \(String(describing: levelData.count))")

            //TODO create/update level selector
            self.levelSelector.updateLevels(self.levelSelector.xTiles, self.levelSelector.yTiles, newLevels: levelData)
        })
        
    }
    
    func animateIn(){
        titleLabel.animateIn()
        backButton.animateIn()
        levelSelector.animateIn()
        //TODO
        self.loadLevels(query: LevelQuery(userId: nil, levelTitle: nil, minimumDownloads: nil, maxResults: nil))
    }

    func animateOut(){
        titleLabel.animateOut()
        backButton.animateOut()
        levelSelector.animateOut()
    }
    
    func getThumbnail(levelUUID: String, completion: @escaping (UIImage) -> Void) {
        globalLevelSelectDelegate?.globalLevelSelect_getThumbnail(uuid: levelUUID, completion: completion)
    }
    
    func globalLevelSelector_pressedPlayLevel(level: GLSLevelData){
        globalLevelSelectDelegate?.globalLevelSelect_pressLevel(level: level)
    }
}
