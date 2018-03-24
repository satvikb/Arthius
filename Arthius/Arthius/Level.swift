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
    
    
    init(_metadata : LevelMetadata, _propFrame : CGRect, _startPosition : CGPoint, _endPosition : CGRect, _startVelocity : CGVector, _startColor : Color, _gravityWells : [GravityWellData], _colorBoxData : [ColorBoxData], _rockData : [RockData], _speedBoostData : [SpeedBoostData]) {
        super.init()
        
        let lD = LevelData(levelMetadata: _metadata, propFrame: _propFrame, startPosition: _startPosition, endPosition: _endPosition, startVelocity: _startVelocity, startColor: _startColor, gravityWells: _gravityWells, colorBoxData: _colorBoxData, rockData: _rockData, speedBoostData: _speedBoostData)
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

struct LevelData : Codable {
    var levelMetadata : LevelMetadata;
    var propFrame : CGRect;
    var startPosition : CGPoint;
    var endPosition : CGRect;
    var startVelocity : CGVector;
    var startColor : Color;
    var gravityWells : [GravityWellData]
    var colorBoxData : [ColorBoxData]
    var rockData : [RockData]
    var speedBoostData : [SpeedBoostData]
    

//    static func archive(w:LevelData) -> Data {
//        var fw = w
//        return Data(bytes: &fw, count: MemoryLayout<LevelData>.stride)
//    }
//
//    static func unarchive(d:Data) -> LevelData {
//        guard d.count == MemoryLayout<LevelData>.stride else {
//            fatalError("BOOM!")
//        }
//
//        var w:LevelData?
//        d.withUnsafeBytes({(bytes: UnsafePointer<LevelData>)->Void in
//            w = UnsafePointer<LevelData>(bytes).pointee
//        })
//        return w!
//    }
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
    
//    static func archive(w:GravityWellData) -> Data {
//        var fw = w
//        return Data(bytes: &fw, count: MemoryLayout<GravityWellData>.stride)
//    }
//
//    static func unarchive(d:Data) -> GravityWellData {
//        guard d.count == MemoryLayout<GravityWellData>.stride else {
//            fatalError("BOOM!")
//        }
//
//        var w:GravityWellData?
//        d.withUnsafeBytes({(bytes: UnsafePointer<GravityWellData>)->Void in
//            w = UnsafePointer<GravityWellData>(bytes).pointee
//        })
//        return w!
//    }
//
}

struct ColorBoxData: Codable {
    var frame : CGRect;
    var rotation : CGFloat;
    var box : Bool;
    var leftColor : Color;
    var rightColor : Color;
    var backgroundColor : Color;
    var middlePropWidth : CGFloat;
}

struct RockData: Codable {
    
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
