//
//  Progress.swift
//  Arthius
//
//  Created by Satvik Borra on 3/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class CampaignLevelHandler {
    static var allLevels : [LevelData]!
    
    static func load(){
        allLevels = File.getAllLevels(type: .Campaign)
    }
    
    static func getLevelFromLevelNumber(levelNumber : Int) -> LevelData? {
        for level in allLevels {
            if(level.levelMetadata.levelNumber == levelNumber){
                return level
            }
        }
        return nil
    }
}


struct CampaignProgress : Codable {
    var progress : [Int : CampaignProgressData];
}

struct CampaignProgressData : Codable {
//    var uuid : String
    var levelNumber : Int
    var completed : Bool
    var locked : Bool
    var stars : Int
    var time : CGFloat
    var distance : CGFloat
    
    static func unlockedTrue(num : Int) -> CampaignProgressData{
        return CampaignProgressData(levelNumber: num, completed: false, locked: false, stars: 0, time: 0, distance: 0)
    }
}

class CampaignProgressHandler {
    
    static var progress : CampaignProgress!;
    
    static func load(){
        progress = File.loadCampaignProgress()
    }
    
    static func completedLevel(levelNumber : Int, data : CampaignProgressData){
        if(progress != nil){
//            if(/*progress.progress != nil*/){
//
//            }
            
            //TODO if progress for level is > data (save only best results)
//            progress.progress[levelNumber] = data
            let _ = self.setProgress(levelNumber, data)
            
            ///////TODO UNLOCK NEXT LEVEL, CREATE BLANK VALUE WITH UNLOCKED=TRUE ?
            progress.progress[levelNumber+1] = CampaignProgressData.unlockedTrue(num: levelNumber+1)
            //TODO USE THIS IN CAMPAIGN LEVEL SELECTOR
            
            
            save()
        }else{
            //not loaded, try again
            self.load()
            completedLevel(levelNumber: levelNumber, data: data) //DANGER: RECURSIVE FOREVER IF LOAD DOESNT WORK PROPERLY
        }
    }
    
    static func setProgress(_ levelNum : Int, _ progress : CampaignProgressData) -> CampaignProgressData{
        let current = self.progress.progress[levelNum];
        
        var dataToSave : CampaignProgressData! = progress;
        if(current != nil){
            dataToSave = CampaignProgressData(levelNumber: levelNum, completed: current!.completed, locked: current!.locked, stars: max(current!.stars, progress.stars), time: min(current!.time, progress.time), distance: min(current!.distance, progress.distance))
        }
        
        self.progress.progress[levelNum] = dataToSave
        save()
        return dataToSave
    }
    
    static func save(){
        File.saveCampaignProgress(progress: progress)
    }
}
