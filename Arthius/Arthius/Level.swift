//
//  Level.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class Level : NSObject{
    
    var levelData : LevelData!;
    
//    var levelName : String! = "";
//    var propFrame : CGRect! = CGRect.zero;
//    var gravityWells : [GravityWellData] = []
    
    
    init(_name : String, _propFrame : CGRect, _startPosition : CGPoint, _startVelocity : CGVector, _gravityWells : [GravityWellData], _colorBoxData : [ColorBoxData], _rockData : [RockData], _speedBoostData : [SpeedBoostData]) {
        super.init()
        
        let lD = LevelData(name: _name, propFrame: _propFrame, startPosition: _startPosition, startVelocity: _startVelocity, gravityWells: _gravityWells, colorBoxData: _colorBoxData, rockData: _rockData, speedBoostData: _speedBoostData)
        levelData = lD;
//        levelName = name;
//        propFrame = _propFrame;
//        gravityWells = _gravityWells;
    }
    
    init(_levelData : LevelData){
        super.init();
        levelData = _levelData;
    }
    
}

struct LevelData {
    var name : String;
    var propFrame : CGRect;
    var startPosition : CGPoint;
    var startVelocity : CGVector;
    var gravityWells : [GravityWellData]
    var colorBoxData : [ColorBoxData]
    var rockData : [RockData]
    var speedBoostData : [SpeedBoostData]
}

struct GravityWellData {
    var position: CGPoint;
    var mass : CGFloat;
    var coreDiameter : CGFloat;
    var areaOfEffectDiameter : CGFloat;
}

struct ColorBoxData {
    
}

struct RockData {
    
}

struct SpeedBoostData {
    
}
