//
//  Level.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

//TODO: what is the point of this lol its literlly just a container for LevelData (unnecessary)
class Level : NSObject{
    
    var levelData : LevelData!;
    
//    init(_metadata : LevelMetadata, _propFrame : CGRect, _startPosition : CGPoint, _endPosition : CGRect, _startVelocity : CGVector, _startColor : Color, _endColor : Color, _gravityWells : [GravityWellData], _colorBoxData : [ColorBoxData], _rockData : [RockData], _speedBoostData : [SpeedBoostData]) {
//        super.init()
//
//        let lD = LevelData(levelMetadata: _metadata, propFrame: _propFrame, startPosition: _startPosition, endPosition: _endPosition, startVelocity: _startVelocity, startColor: _startColor, endColor: _endColor, gravityWells: _gravityWells, colorBoxData: _colorBoxData, rockData: _rockData, speedBoostData: _speedBoostData)
//        levelData = lD;
//    }
    
    init(_levelData : LevelData){
        super.init();
        levelData = _levelData;
    }
    
}

struct LevelData : Codable {
    var levelMetadata : LevelMetadata;
    var propFrame : CGRect;
    var endPoints : [EndData];
    var lineData : [LineData]
    var gravityWells : [GravityWellData]
    var colorBoxData : [ColorBoxData]
    var rockData : [RockData]
    var speedBoostData : [SpeedBoostData]
}

struct LineData : Codable{
    var startPosition : CGPoint;
    var startVelocity : CGVector;
    var startColor : Color;
}

struct EndData : Codable{
    var outerFrame : CGRect;
    var coreFrame : CGRect; //treated as: propToRect(coreFrame, within: outerFrame)
    var endColor : Color;
}

struct LevelMetadata : Codable {
    var levelUUID : String;
    var levelNumber : Int; // can definetely be hacked, just used for numbering purposes in campaign levels or whatever else
    var levelName : String;
    var levelVersion : String; // allows for "version Epic" instead of just boring numbers
    var levelAuthor : String;
}

struct GravityWellData : Codable, Equatable{
    var position: CGPoint;
    var mass : CGFloat;
    var coreDiameter : CGFloat;
    var areaOfEffectDiameter : CGFloat;
}

struct ColorBoxData: Codable, Equatable {
    var frame : CGRect;
    var rotation : CGFloat;
    var box : Bool;
    var leftColor : Color;
    var rightColor : Color;
    var backgroundColor : Color;
    var middlePropWidth : CGFloat;
}

struct RockData: Codable {
//    var frame: CGRect;
    
}

struct SpeedBoostData: Codable {
    var frame : CGRect;
    var rotation : CGFloat;
    var box : Bool;
}

// 0-1 values
struct Color : Codable, Equatable{
    var r : CGFloat;
    var g : CGFloat;
    var b : CGFloat;
    var a : CGFloat
}
