//
//  Progress.swift
//  Arthius
//
//  Created by Satvik Borra on 3/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

struct CampaignProgress : Codable {
    var progress : [String : CampaignProgressData];
}

struct CampaignProgressData : Codable {
//    var uuid : String
    var levelNumber : Int
    var completed : Bool
    var locked : Bool
    var stars : Int
    var time : CGFloat
    var distance : CGFloat
}

class CampaignProgressHandler {
    
    static var progress : CampaignProgress!;
    
    static func load(){
        progress = File.loadCampaignProgress()
    }
    
    static func completedLevel(uuid : String, data : CampaignProgressData){
        if(progress != nil){
//            if(/*progress.progress != nil*/){
//
//            }
            progress.progress[uuid] = data
            //TODO UNLOCK NEXT LEVEL, CREATE BLANK VALUE WITH UNLOCKED=TRUE ?
            save()
        }else{
            //not loaded, try again
            self.load()
            completedLevel(uuid: uuid, data: data) //DANGER: RECURSIVE FOREVER IF LOAD DOESNT WORK PROPERLY
        }
    }
    
    static func save(){
        File.saveCampaignProgress(progress: progress)
    }
}
