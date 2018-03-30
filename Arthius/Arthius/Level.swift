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
    
    init(_levelData : LevelData){
        super.init();
        levelData = _levelData;
    }
    
}

enum LevelTextTriggers : String, Codable {
    case none = ""
    case tap = "Tap"
    case pressPlay = "Play"
    //TODO based on these, a lot of customization is possbible, but too bad its only text
}

struct LevelText : Codable {
    var id: Int
    var showFirst: Bool;
    var text: String;
    var triggerOn: LevelTextTriggers;
    var nextText: Int;
    var animateOut: Bool; //animates out the current one, after animation FINISHES new one comes in (its after cuz i dont want to keep track of 2+ LevelTextLabels)
    //TODO animation time
}

struct LevelData : Codable {
    var levelMetadata : LevelMetadata;
    var texts : [LevelText];
    var propFrame : CGRect;
    var endPoints : [EndData];
    var lineData : [LineData]
    var gravityWells : [GravityWellData]
    var colorBoxData : [ColorBoxData]
    var rockData : [RockData]
    var speedBoostData : [SpeedBoostData]
}

struct LineData : Codable, Equatable{
//    static func ==(lhs: LineData, rhs: LineData) -> Bool {
//        return lhs.startPosition == rhs.startPosition && lhs.startVelocity == rhs.startVelocity && lhs.startColor == rhs.startColor
//    }
    
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
//    static func ==(lhs: GravityWellData, rhs: GravityWellData) -> Bool {
//        return lhs.position == rhs.position && lhs.mass == rhs.mass && lhs.coreDiameter == rhs.coreDiameter && lhs.areaOfEffectDiameter == rhs.areaOfEffectDiameter
//    }
    
    var position: CGPoint;
    var mass : CGFloat;
    var coreDiameter : CGFloat;
    var areaOfEffectDiameter : CGFloat;
}

struct ColorBoxData: Codable, Equatable {
//    static func ==(lhs: ColorBoxData, rhs: ColorBoxData) -> Bool {
//        return lhs.frame == rhs.frame && lhs.rotation == rhs.rotation && lhs.box == rhs.box && lhs.leftColor == rhs.leftColor && lhs.rightColor == rhs.rightColor && lhs.backgroundColor == rhs.backgroundColor && lhs.middlePropWidth == rhs.middlePropWidth;
//    }
    
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
//    static func ==(lhs: Color, rhs: Color) -> Bool {
//        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == lhs.b && lhs.a == rhs.a
//    }
    
    var r : CGFloat;
    var g : CGFloat;
    var b : CGFloat;
    var a : CGFloat
}
