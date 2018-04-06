//
//  Progress.swift
//  Arthius
//
//  Created by Satvik Borra on 3/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import Foundation

struct CampaignProgress {
    var progress : [String : CampaignProgressData];
}

struct CampaignProgressData : Codable {
//    var uuid : String
    var levelNumber : Bool
    var completed : Bool
    var locked : Bool
    var stars : Int
    var time : CGFloat
    var distance : CGFloat
}
