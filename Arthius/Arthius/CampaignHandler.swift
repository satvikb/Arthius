//
//  Progress.swift
//  Arthius
//
//  Created by Satvik Borra on 3/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

//TODO FLAT BUFFERS

class CampaignLevelHandler {
    static var allLevels : [LevelData]!
    
    static func load(){
        allLevels = File.getAllLevels(type: .Campaign)
    }
    
    static func getLevelFromLevelNumber(levelNumber : Int) -> LevelData? {
        for level in allLevels {
            if(Int((level.levelMetadata?.levelNumber)!) == levelNumber){
                return level
            }
        }
        return nil
    }
    
    static func getLevelFromLevelUUID(uuid : String) -> LevelData? {
        //TODO use index where
        for level in allLevels {
            if(level.levelMetadata?.levelUUID == uuid){
                return level
            }
        }
        return nil
    }
}


//struct CampaignProgress : Codable {
//    var progress : [Int : CampaignProgressData];
//}
//
//struct CampaignProgressData : Codable {
////    var uuid : String
//    var levelUUID : UInt128
//    var completed : Bool
//    var locked : Bool
//    var stars : Int
//    var time : CGFloat
//    var distance : CGFloat
//
//    static func unlockedTrue(num : Int) -> CampaignProgressData{
//        return CampaignProgressData(levelNumber: num, completed: false, locked: false, stars: 0, time: 0, distance: 0)
//    }
//}

class ProgressHandler {
    
    static var progress : Progress!;
    
    static func load(){
        progress = File.loadProgress()
    }
    
    static func completedLevel(data : LevelProgressData, repeatCount : Int = 0){
        if(progress != nil){
            let _ = self.setProgress(data);
            save()
        }else{
            if(repeatCount <= 3){ //TODO use repeat count?
                //not loaded, try again
                self.load()
                completedLevel(data: data, repeatCount: repeatCount+1)
            }
        }
    }
    
    static func completedCampaignLevel(data : LevelProgressData, repeatCount : Int = 0){
        if(progress != nil){
            let _ = self.setProgress(data)
            
            let currentLevelData = CampaignLevelHandler.getLevelFromLevelUUID(uuid: data.uuid!)
            let nextId = Int(currentLevelData!.levelMetadata!.levelNumber)+1;
            let nextLevel = CampaignLevelHandler.getLevelFromLevelNumber(levelNumber: nextId);
            
            if(nextLevel != nil){
                let nextLevelUUID = nextLevel?.levelMetadata?.levelUUID;
                let blankUnlockData = LevelProgressData(uuid: nextLevelUUID, completed: false, locked: false, stars: 0, time: 0, distance: 0);
                self.setProgress(blankUnlockData);
            }
            
            
            save()
        }else{
            //not loaded, try again
            if(repeatCount <= 3){
                self.load()
                completedCampaignLevel(data: data, repeatCount: repeatCount+1);
            }
        }
    }
    
    static func setProgress(_ progress : LevelProgressData){//} -> LevelProgressData{
        setProgressForUUID(newProgressData: progress)
        save()
//        return progress //TODO ??
    }
    
    static func getCurrentProgressForUUID(uuid : String) -> LevelProgressData?{
        for progressData in progress.progressData{
            if(progressData.uuid == uuid){
                return progressData
            }
        }
        return nil
    }
    
    static func setProgressForUUID(newProgressData : LevelProgressData){
        let i = progress.progressData.index { (levelProgressData : LevelProgressData) -> Bool in
            newProgressData.uuid == levelProgressData.uuid;
        }

        if(i != nil){
            //can replace
            
            //TODO only replace if stats are better, NO MIXING (best time from one and best distance from another), find a way to compare the two statistics together
            
//            var currentData = progress.progressData[i];
            let bestData = newProgressData;
            
            progress.progressData[i!] = bestData;
        }else{
            //append
            progress.progressData.append(newProgressData);
        }
    }
    
    static func save(){
        File.saveProgress(progress: progress)
    }
}
