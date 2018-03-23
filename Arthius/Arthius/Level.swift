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
    
    
    init(_name : String, _propFrame : CGRect, _startPosition : CGPoint, _endPosition : CGRect, _startVelocity : CGVector, _gravityWells : [GravityWellData], _colorBoxData : [ColorBoxData], _rockData : [RockData], _speedBoostData : [SpeedBoostData]) {
        super.init()
        
        let lD = LevelData(name: _name, propFrame: _propFrame, startPosition: _startPosition, endPosition: _endPosition, startVelocity: _startVelocity, gravityWells: _gravityWells, colorBoxData: _colorBoxData, rockData: _rockData, speedBoostData: _speedBoostData)
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
    var name : String;
    var propFrame : CGRect;
    var startPosition : CGPoint;
    var endPosition : CGRect;
    var startVelocity : CGVector;
    var gravityWells : [GravityWellData]
    var colorBoxData : [ColorBoxData]
    var rockData : [RockData]
    var speedBoostData : [SpeedBoostData]
    

    static func archive(w:LevelData) -> Data {
        var fw = w
        return Data(bytes: &fw, count: MemoryLayout<LevelData>.stride)
    }
    
    static func unarchive(d:Data) -> LevelData {
        guard d.count == MemoryLayout<LevelData>.stride else {
            fatalError("BOOM!")
        }
        
        var w:LevelData?
        d.withUnsafeBytes({(bytes: UnsafePointer<LevelData>)->Void in
            w = UnsafePointer<LevelData>(bytes).pointee
        })
        return w!
    }
    
    
    
}

struct GravityWellData : Codable, Equatable{
    var position: CGPoint;
    var mass : CGFloat;
    var coreDiameter : CGFloat;
    var areaOfEffectDiameter : CGFloat;
    
    static func archive(w:GravityWellData) -> Data {
        var fw = w
        return Data(bytes: &fw, count: MemoryLayout<GravityWellData>.stride)
    }
    
    static func unarchive(d:Data) -> GravityWellData {
        guard d.count == MemoryLayout<GravityWellData>.stride else {
            fatalError("BOOM!")
        }
        
        var w:GravityWellData?
        d.withUnsafeBytes({(bytes: UnsafePointer<GravityWellData>)->Void in
            w = UnsafePointer<GravityWellData>(bytes).pointee
        })
        return w!
    }
    
}

struct ColorBoxData: Codable {
    
}

struct RockData: Codable {
    
}

struct SpeedBoostData: Codable {
    
}
