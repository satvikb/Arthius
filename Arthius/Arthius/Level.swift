//
//  Level.swift
//  Arthius
//
//  Created by Satvik Borra on 3/21/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit


func convertJSONLevelToLevel(jsonLevel: Level2) -> Level {
    let d = jsonLevel.levelData!
    let m = d.levelMetadata;
    let c = d.levelConditions;
    
    var texts : [LevelText] = []
    for text in d.texts {
        
        let binText = LevelText(id: Int32(text.id), text: text.text, triggerOn: LevelTextTriggers(rawValue: Int8(text.triggerOn.rawValue)), nextText: Int32(text.nextText), animateTime: Float32(text.animateTime), animateIn: text.animateIn, animateOut: text.animateOut, propFrame: text.propFrame.rect, fontColor: text.fontColor.uiColor().color, fontSize: Int32(text.fontSize))
        texts.append(binText);
    }
    
    
    var endPoints : [EndData] = []
    for end in d.endPoints {
        let binEnd = EndData(frame: end.coreFrame.rect, color: end.endColor.uiColor().color)
        endPoints.append(binEnd);
    }
    
    
    var lineData : [LineData] = []
    for j in d.lineData {
        let bin = LineData(startPosition: j.startPosition.point, startVelocity: j.startVelocity.vector, startColor: j.startColor.uiColor().color, startThickness: Float32(j.startThickness))
        lineData.append(bin);
    }
    
    
    var gravityWells : [GravityWellData] = []
    for j in d.gravityWells {
        let bin = GravityWellData(position: j.position.point, mass: Float32(j.mass), coreDiameter: Float32(j.coreDiameter), areaOfEffectDiameter: Float32(j.areaOfEffectDiameter))
        gravityWells.append(bin);
    }
    
    
    var colorBoxes : [ColorBoxData] = []
    for j in d.colorBoxData {
        let bin = ColorBoxData(frame: j.frame.rect, rotation: Float32(j.rotation), leftColor: j.leftColor.uiColor().color, rightColor: j.rightColor.uiColor().color, backgroundColor: j.backgroundColor.uiColor().color, middlePropWidth: Float32(j.middlePropWidth));
        colorBoxes.append(bin);
    }
    
    
    var rockData : [RockData] = []
    for j in d.rockData {
        let bin = RockData(position: j.position.point, diameter: Float32(j.diameter));
        rockData.append(bin);
    }

    
    var antiGravityData : [AntiGravityData] = []
    for j in d.antiGravityZones {
        let bin = AntiGravityData(frame: j.frame.rect, color: j.color.uiColor().color)
        antiGravityData.append(bin);
    }
    
    //phew
    let binaryLevel = Level(levelData: LevelData(levelMetadata: LevelMetadata(levelUUID: m.levelUUID, levelNumber: Int32(m.levelNumber), levelName: m.levelName, levelVersion: m.levelVersion, levelAuthor: m.levelAuthor, levelThumbnail: m.levelThumbnail.rect), levelConditions: LevelConditions(maxDistance: Float32(c.maxDistance), maxTime: Float32(c.maxTime)), texts: texts, propFrame: d.propFrame.rect, endPoints: endPoints, lineData: lineData, gravityWells: gravityWells, colorBoxData: colorBoxes, rockData: rockData, antiGravityZones: antiGravityData))
    return binaryLevel;
}




//TODO: what is the point of this lol its literlly just a container for LevelData (unnecessary)
class Level2 : NSObject{
    var levelData : LevelData2!;

    init(_levelData : LevelData2){
        super.init();
        levelData = _levelData;
    }

}

enum LevelTextTriggers2 : Int, Codable {
    case none = 0
    case start = 1
    case tap = 2
    case pressPlay = 3
    //TODO based on these, a lot of customization is possbible, but too bad its only text
}

struct LevelText2 : Codable {
    var id: Int
//    var showFirst: Bool;
    var text: String;
    var triggerOn: LevelTextTriggers2;
    var nextText: Int;
    var animateTime: CGFloat;
    var animateIn: Bool;
    var animateOut: Bool; //animates out the current one, after animation FINISHES new one comes in (its after cuz i dont want to keep track of 2+ LevelTextLabels)
    //TODO animation time
    var propFrame : CGRect;
    var fontSize : CGFloat;
    var fontColor: Color2;
}

struct LevelData2 : Codable {
    var levelMetadata : LevelMetadata2;
    var levelConditions : LevelConditions2;
    var texts : [LevelText2];
    var propFrame : CGRect;
    var endPoints : [EndData2];
    var lineData : [LineData2]
    var gravityWells : [GravityWellData2]
    var colorBoxData : [ColorBoxData2]
    var rockData : [RockData2]
    var antiGravityZones : [AntiGravityData2]
//    var speedBoostData : [SpeedBoostData]
}

struct LevelConditions2 : Codable{
    var maxDistance : CGFloat;
    var maxTime : CGFloat;
}

struct LineData2 : Codable, Equatable{
//    static func ==(lhs: LineData, rhs: LineData) -> Bool {
//        return lhs.startPosition == rhs.startPosition && lhs.startVelocity == rhs.startVelocity && lhs.startColor == rhs.startColor
//    }

    var startPosition : CGPoint;
    var startVelocity : CGVector;
    var startColor : Color2;
    var startThickness : CGFloat;
}

struct AntiGravityData2 : Codable{
    var frame : CGRect;
    var color : Color2; //ANTI GRAVITY ONLY AFFECTS LINES OF CERTAIN COLORS?? <- IF SO, == COLORS IMPOSSIBLE TO SEE, OR JUST VISUAL??
}

struct EndData2 : Codable{
    var coreFrame : CGRect;
    var endColor : Color2;
}

struct LevelMetadata2 : Codable {
    var levelUUID : String;
    var levelNumber : Int; // can definetely be hacked, just used for numbering purposes in campaign levels or whatever else
    var levelName : String;
    var levelVersion : String; // allows for "version Epic" instead of just boring numbers
    var levelAuthor : String;
    var levelThumbnail : CGRect;
}

struct GravityWellData2 : Codable, Equatable{
//    static func ==(lhs: GravityWellData, rhs: GravityWellData) -> Bool {
//        return lhs.position == rhs.position && lhs.mass == rhs.mass && lhs.coreDiameter == rhs.coreDiameter && lhs.areaOfEffectDiameter == rhs.areaOfEffectDiameter
//    }

    var position: CGPoint;
    var mass : CGFloat;
    var coreDiameter : CGFloat;
    var areaOfEffectDiameter : CGFloat;
}

struct ColorBoxData2: Codable, Equatable {
//    static func ==(lhs: ColorBoxData, rhs: ColorBoxData) -> Bool {
//        return lhs.frame == rhs.frame && lhs.rotation == rhs.rotation && lhs.box == rhs.box && lhs.leftColor == rhs.leftColor && lhs.rightColor == rhs.rightColor && lhs.backgroundColor == rhs.backgroundColor && lhs.middlePropWidth == rhs.middlePropWidth;
//    }

    var frame : CGRect;
    var rotation : CGFloat;
    var box : Bool;
    var leftColor : Color2;
    var rightColor : Color2;
    var backgroundColor : Color2;
    var middlePropWidth : CGFloat;
}

struct RockData2: Codable {
    var position: CGPoint;
    var diameter: CGFloat;
}
//
//struct SpeedBoostData: Codable {
//    var frame : CGRect;
//    var rotation : CGFloat;
//    var box : Bool;
//}

// 0-1 values
struct Color2 : Codable, Equatable{
//    static func ==(lhs: Color, rhs: Color) -> Bool {
//        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == lhs.b && lhs.a == rhs.a
//    }

    var r : CGFloat;
    var g : CGFloat;
    var b : CGFloat;
    var a : CGFloat;

    func uiColor() -> UIColor{
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
